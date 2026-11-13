import 'package:flutter/material.dart';

class ReportFileMetadata {
  final String fileName;
  final String reportType; // 'passageiros', 'saldos', 'linhas', 'viagens'
  final String periodicity; // 'mensal' ou 'quinzenal'
  final String periodReference; // ex: '202611'

  ReportFileMetadata({
    required this.fileName,
    required this.reportType,
    required this.periodicity,
    required this.periodReference,
  });

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'reportType': reportType,
        'periodicity': periodicity,
        'periodReference': periodReference,
      };
}

class PassengerReportRecord {
  final String linha;
  final String nomeLinha;
  final int totalPassageiros;
  final int gratuidade;
  final double valorTotal;
  final String pontualidade;
  final String status;

  PassengerReportRecord({
    required this.linha,
    this.nomeLinha = '',
    required this.totalPassageiros,
    required this.gratuidade,
    required this.valorTotal,
    this.pontualidade = '95%',
    this.status = 'Operando',
  });

  Map<String, dynamic> toJson() => {
        'codigo': linha,
        'nome': nomeLinha.isEmpty ? 'Linha Municipal $linha' : nomeLinha,
        'passageiros': totalPassageiros,
        'gratuidade': gratuidade,
        'receita': valorTotal,
        'pontualidade': pontualidade,
        'status': status,
      };

  factory PassengerReportRecord.fromJson(Map<String, dynamic> json) {
    return PassengerReportRecord(
      linha: (json['codigo'] ?? json['linha'] ?? '').toString(),
      nomeLinha: (json['nome'] ?? json['nomeLinha'] ?? '').toString(),
      totalPassageiros: (json['passageiros'] ?? json['totalPassageiros'] ?? 0) as int,
      gratuidade: (json['gratuidade'] ?? 0) as int,
      valorTotal: ((json['receita'] ?? json['valorTotal'] ?? 0.0) as num).toDouble(),
      pontualidade: (json['pontualidade'] ?? '95%').toString(),
      status: (json['status'] ?? 'Operando').toString(),
    );
  }

  Color get badgeColor {
    switch (linha) {
      case '001':
        return const Color(0xFF003B71);
      case '002':
        return const Color(0xFF0066B3);
      case '003':
        return const Color(0xFF1B365D);
      case '004':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF2E7D32);
    }
  }
}

class ImportBatchResult {
  final int filesProcessed;
  final int recordsExtracted;
  final List<PassengerReportRecord> records;
  final String message;

  ImportBatchResult({
    required this.filesProcessed,
    required this.recordsExtracted,
    required this.records,
    required this.message,
  });
}