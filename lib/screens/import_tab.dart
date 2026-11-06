import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as excel_lib;

import '../services/semob_zip_service.dart';
import '../services/semob_html_parser.dart';
import '../services/semob_import_facade.dart';
import '../models/semob_report_models.dart';

class ImportTab extends StatefulWidget {
  const ImportTab({Key? key}) : super(key: key);

  @override
  State<ImportTab> createState() => _ImportTabState();
}

class _ImportTabState extends State<ImportTab> {
  final SemobImportFacade _importFacade = SemobImportFacade();
  final SemobHtmlParser _htmlParser = SemobHtmlParser();

  bool _isImporting = false;
  String _statusMessage = 'Nenhum ficheiro importado ainda.';

  Future<void> _pickAndProcessFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'html', 'htm', 'xlsx', 'xls'],
        allowMultiple: true,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _statusMessage = 'Seleção de ficheiros cancelada.';
        });
        return;
      }

      setState(() {
        _isImporting = true;
        _statusMessage = 'A processar ${result.files.length} ficheiro(s)...';
      });

      int successCount = 0;

      for (var file in result.files) {
        final fileName = file.name.toLowerCase();
        final Uint8List? bytes = file.bytes;

        if (bytes == null || bytes.isEmpty) continue;

        if (fileName.endsWith('.zip')) {
          await _importFacade.processZipPackage(bytes);
          successCount++;
        } else if (fileName.endsWith('.html') || fileName.endsWith('.htm')) {
          if (fileName.contains('passageiros')) {
            final records = _htmlParser.parsePassengerReport(bytes);
            debugPrint('Passageiros importados: ${records.length}');
          }
          successCount++;
        } else if (fileName.endsWith('.xlsx') || fileName.endsWith('.xls')) {
          var excelDoc = excel_lib.Excel.decodeBytes(bytes);
          for (var table in excelDoc.tables.keys) {
            debugPrint('Tabela encontrada: $table com ${excelDoc.tables[table]?.maxRows} linhas');
          }
          successCount++;
        }
      }

      setState(() {
        _statusMessage = 'Importação concluída com sucesso! ($successCount ficheiro(s) processado(s))';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro ao importar ficheiros: $e';
      });
    } finally {
      setState(() {
        _isImporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 64,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Importar Relatórios do Transporte Municipal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selecione pacotes .ZIP ou ficheiros avulsos (.HTML, .HTM, .XLSX)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isImporting ? null : _pickAndProcessFiles,
                    icon: _isImporting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.folder_open),
                    label: Text(_isImporting ? 'A importar...' : 'Selecionar Ficheiros'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Estado da Importação:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Text(
              _statusMessage,
              style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}