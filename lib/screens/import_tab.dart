import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/semob_import_facade.dart';
import '../models/semob_report_models.dart';

class ImportTab extends StatefulWidget {
  final VoidCallback? onImportSuccess;

  const ImportTab({super.key, this.onImportSuccess});

  @override
  State<ImportTab> createState() => _ImportTabState();
}

class _ImportTabState extends State<ImportTab> {
  final SemobImportFacade _importFacade = SemobImportFacade();

  bool _isImporting = false;
  String _statusMessage = 'Nenhum arquivo importado nesta sessão.';

  Future<void> _pickAndProcessFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'html', 'htm', 'xlsx', 'xls'],
        allowMultiple: true,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _statusMessage = 'Seleção de arquivos cancelada.');
        return;
      }

      setState(() {
        _isImporting = true;
        _statusMessage = 'Processando ${result.files.length} arquivo(s)...';
      });

      int totalFiles = 0;
      int totalRecords = 0;

      for (var file in result.files) {
        final fileName = file.name.toLowerCase();
        final Uint8List? bytes = file.bytes;

        if (bytes == null || bytes.isEmpty) continue;

        ImportBatchResult? batchResult;

        if (fileName.endsWith('.zip')) {
          batchResult = await _importFacade.processZipPackage(bytes);
        } else if (fileName.endsWith('.html') || fileName.endsWith('.htm')) {
          batchResult = await _importFacade.processHtmlFile(bytes);
        } else if (fileName.endsWith('.xlsx') || fileName.endsWith('.xls')) {
          batchResult = await _importFacade.processExcelFile(bytes);
        }

        if (batchResult != null) {
          totalFiles += batchResult.filesProcessed;
          totalRecords += batchResult.recordsExtracted;
        }
      }

      setState(() {
        _statusMessage =
            'Concluído! $totalFiles arquivo(s) processado(s) e $totalRecords registro(s) atualizado(s) no painel.';
      });

      if (widget.onImportSuccess != null) {
        widget.onImportSuccess!();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$totalRecords registro(s) importado(s) e sincronizado(s)!'),
            backgroundColor: const Color(0xFF003B71),
          ),
        );
      }
    } catch (e) {
      setState(() => _statusMessage = 'Erro ao importar arquivos: $e');
    } finally {
      setState(() => _isImporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003B71).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cloud_upload_outlined, size: 48, color: Color(0xFF003B71)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Importar Relatórios Operacionais (SEMOB / VIPE)',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF003B71)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selecione pacotes .ZIP ou relatórios avulsos (.HTML, .HTM, .XLSX) para atualizar os indicadores e enviar ao repositório.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isImporting ? null : _pickAndProcessFiles,
                  icon: _isImporting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.folder_open),
                  label: Text(_isImporting ? 'Processando...' : 'Selecionar Arquivos (.ZIP / .HTML / .XLSX)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003B71),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Log de Processamento:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF003B71)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD1D5DB)),
          ),
          child: Row(
            children: [
              const Icon(Icons.terminal, size: 18, color: Color(0xFF003B71)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(fontSize: 13, fontFamily: 'monospace', color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}