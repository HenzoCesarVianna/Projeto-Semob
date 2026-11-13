import 'dart:typed_data';
import 'package:excel/excel.dart' as excel_lib;
import 'semob_zip_service.dart';
import 'semob_html_parser.dart';
import 'semob_repository.dart';
import '../models/semob_report_models.dart';

class SemobImportFacade {
  final SemobZipService _zipService = SemobZipService();
  final SemobHtmlParser _htmlParser = SemobHtmlParser();
  final SemobRepository _repository = SemobRepository.instance;

  /// Processa um pacote .ZIP completo e envia os dados para o repositório
  Future<ImportBatchResult> processZipPackage(List<int> zipBytes) async {
    final filesMap = _zipService.extractZipContents(zipBytes);
    final List<PassengerReportRecord> allExtracted = [];

    for (final entry in filesMap.entries) {
      final fileName = entry.key.split('/').last.toLowerCase();
      final bytes = entry.value;

      if (fileName.contains('passageiros') || fileName.endsWith('.html') || fileName.endsWith('.htm')) {
        final records = _htmlParser.parsePassengerReport(bytes);
        allExtracted.addAll(records);
      }
    }

    if (allExtracted.isNotEmpty) {
      await _repository.saveImportedRecords(allExtracted, sourceType: 'zip_package');
    }

    return ImportBatchResult(
      filesProcessed: filesMap.length,
      recordsExtracted: allExtracted.length,
      records: allExtracted,
      message: 'Pacote ZIP processado: ${filesMap.length} arquivo(s) lido(s), ${allExtracted.length} registro(s) atualizado(s).',
    );
  }

  /// Processa planilha Excel (.XLSX / .XLS) e envia para o repositório
  Future<ImportBatchResult> processExcelFile(Uint8List bytes) async {
    final excelDoc = excel_lib.Excel.decodeBytes(bytes);
    final List<PassengerReportRecord> extracted = [];

    for (final tableName in excelDoc.tables.keys) {
      final sheet = excelDoc.tables[tableName];
      if (sheet == null) continue;

      // Pula o cabeçalho (linha 0)
      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        final row = sheet.rows[rowIndex];
        if (row.length < 3) continue;

        final linha = row[0]?.value?.toString().trim() ?? '';
        if (linha.isEmpty) continue;

        final passageiros = int.tryParse(row[1]?.value?.toString().replaceAll('.', '').trim() ?? '0') ?? 0;
        final gratuidade = int.tryParse(row[2]?.value?.toString().replaceAll('.', '').trim() ?? '0') ?? 0;
        final valor = row.length >= 4
            ? (double.tryParse(row[3]?.value?.toString().replaceAll('R\$', '').replaceAll(',', '.').trim() ?? '0') ?? 0.0)
            : 0.0;

        extracted.add(PassengerReportRecord(
          linha: linha,
          totalPassageiros: passageiros,
          gratuidade: gratuidade,
          valorTotal: valor,
        ));
      }
    }

    if (extracted.isNotEmpty) {
      await _repository.saveImportedRecords(extracted, sourceType: 'excel_file');
    }

    return ImportBatchResult(
      filesProcessed: 1,
      recordsExtracted: extracted.length,
      records: extracted,
      message: 'Planilha Excel processada: ${extracted.length} linha(s) importada(s).',
    );
  }

  /// Processa arquivo HTML avulso
  Future<ImportBatchResult> processHtmlFile(Uint8List bytes) async {
    final records = _htmlParser.parsePassengerReport(bytes);
    if (records.isNotEmpty) {
      await _repository.saveImportedRecords(records, sourceType: 'html_file');
    }

    return ImportBatchResult(
      filesProcessed: 1,
      recordsExtracted: records.length,
      records: records,
      message: 'Relatório HTML processado: ${records.length} registro(s) extraído(s).',
    );
  }
}