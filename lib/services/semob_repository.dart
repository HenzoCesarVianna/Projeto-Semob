import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/semob_report_models.dart';

class SemobRepository {
  static final SemobRepository instance = SemobRepository._internal();
  SemobRepository._internal();

  /// Mude para `true` ou ative na aba Configurações quando o Backend estiver ativo
  bool useBackendApi = false;
  String baseUrl = 'http://localhost:3000/api/semob';

  // Inicia completamente vazio (sem dados fictícios)
  final List<PassengerReportRecord> _localRecords = [];

  /// Busca os registros das linhas (do Backend REST ou da Memória Local)
  Future<List<PassengerReportRecord>> getLinesData({String period = 'Hoje'}) async {
    if (useBackendApi) {
      try {
        final uri = Uri.parse('$baseUrl/linhas?periodo=${Uri.encodeComponent(period)}');
        final response = await http.get(uri).timeout(const Duration(seconds: 8));

        if (response.statusCode == 200) {
          final List<dynamic> decoded = jsonDecode(response.body);
          return decoded.map((e) => PassengerReportRecord.fromJson(e)).toList();
        }
        debugPrint('Erro HTTP ${response.statusCode} ao buscar linhas.');
      } catch (e) {
        debugPrint('Falha de conexão com Backend ($e).');
      }
    }

    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_localRecords);
  }

  /// Salva registros importados (atualiza a memória local e envia POST se a API estiver ativa)
  Future<bool> saveImportedRecords(List<PassengerReportRecord> newRecords, {String sourceType = 'manual'}) async {
    for (final rec in newRecords) {
      final index = _localRecords.indexWhere(
        (item) => item.linha.contains(rec.linha) || rec.linha.contains(item.linha),
      );
      if (index != -1) {
        final existing = _localRecords[index];
        _localRecords[index] = PassengerReportRecord(
          linha: existing.linha,
          nomeLinha: rec.nomeLinha.isNotEmpty ? rec.nomeLinha : existing.nomeLinha,
          totalPassageiros: rec.totalPassageiros,
          gratuidade: rec.gratuidade,
          valorTotal: rec.valorTotal,
          pontualidade: existing.pontualidade,
          status: existing.status,
        );
      } else {
        _localRecords.add(rec);
      }
    }

    if (useBackendApi) {
      try {
        final uri = Uri.parse('$baseUrl/importacoes');
        final payload = jsonEncode({
          'origem': sourceType,
          'dataImportacao': DateTime.now().toIso8601String(),
          'registros': newRecords.map((r) => r.toJson()).toList(),
        });

        final response = await http
            .post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: payload,
            )
            .timeout(const Duration(seconds: 10));

        return response.statusCode == 200 || response.statusCode == 201;
      } catch (e) {
        debugPrint('Erro ao enviar lote ao Backend: $e');
        return false;
      }
    }

    return true;
  }

  /// Limpa os dados em memória
  void clearLocalData() {
    _localRecords.clear();
  }

  /// Testa se o servidor Backend está respondendo
  Future<bool> testBackendConnection(String urlToTest) async {
    try {
      final cleanUrl = urlToTest.trim().replaceAll(RegExp(r'/$'), '');
      final uri = Uri.parse('$cleanUrl/health');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        baseUrl = cleanUrl;
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}