import 'dart:typed_data';
import 'semob_zip_service.dart';
import 'semob_html_parser.dart';
import '../models/semob_report_models.dart';

class SemobImportFacade {
  final SemobZipService _zipService = SemobZipService();
  final SemobHtmlParser _htmlParser = SemobHtmlParser();

  /// Processa o pacote .zip completo recebido
  Future<void> processZipPackage(List<int> zipBytes) async {
    final filesMap = _zipService.extractZipContents(zipBytes);

    filesMap.forEach((filePath, bytes) {
      final fileName = filePath.split('/').last.toLowerCase();

      // Identifica o tipo de arquivo pela nomenclatura estipulada
      if (fileName.contains('passageiros')) {
        final records = _htmlParser.parsePassengerReport(bytes);
        _saveToDatabase('passageiros', records);
      } else if (fileName.contains('saldos')) {
        // Implementar parser de saldos...
      } else if (fileName.contains('linhas')) {
        // Implementar parser de linhas...
      } else if (fileName.contains('viagens') || fileName.contains('viag')) {
        // Implementar parser de viagens...
      }
    });
  }

  void _saveToDatabase(String type, List<dynamic> data) {
    // Integração com seu banco de dados (ex: MongoDB / MySQL / Firestore)
    print('Salvando ${data.length} registros do tipo: $type');
  }
}