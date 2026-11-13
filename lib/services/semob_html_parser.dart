import 'dart:convert';
import 'dart:typed_data';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';
import '../models/semob_report_models.dart';

class SemobHtmlParser {
  /// Decodifica o conteúdo aceitando UTF-8 e fallback para Latin1 (ISO-8859-1)
  String decodeContent(Uint8List bytes) {
    try {
      return utf8.decode(bytes);
    } catch (_) {
      return latin1.decode(bytes);
    }
  }

  /// Converte tabelas do relatório de Passageiros em objetos Dart
  List<PassengerReportRecord> parsePassengerReport(Uint8List fileBytes) {
    final htmlContent = decodeContent(fileBytes);
    final Document document = html_parser.parse(htmlContent);
    final List<PassengerReportRecord> records = [];

    // Seleciona as linhas das tabelas (ajuste seletores conforme a tag do relatório legado)
    final rows = document.querySelectorAll('table tr');

    for (var i = 1; i < rows.length; i++) {
      final cols = rows[i].querySelectorAll('td');
      if (cols.length >= 4) {
        final linha = cols[0].text.trim();
        final totalPassageiros = int.tryParse(cols[1].text.replaceAll('.', '').trim()) ?? 0;
        final gratuidade = int.tryParse(cols[2].text.replaceAll('.', '').trim()) ?? 0;
        final valorTotal = double.tryParse(
          cols[3].text.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.').trim(),
        ) ?? 0.0;

        records.add(PassengerReportRecord(
          linha: linha,
          totalPassageiros: totalPassageiros,
          gratuidade: gratuidade,
          valorTotal: valorTotal,
        ));
      }
    }

    return records;
  }
}