import 'dart:typed_data';
import 'package:archive/archive.dart';

class SemobZipService {
  /// Extrai o arquivo .zip e retorna um mapa contendo [caminho_do_arquivo: bytes_do_conteudo]
  Map<String, Uint8List> extractZipContents(List<int> zipBytes) {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    final Map<String, Uint8List> extractedFiles = {};

    for (final file in archive) {
      if (file.isFile && (file.name.endsWith('.html') || file.name.endsWith('.htm'))) {
        extractedFiles[file.name] = file.content as Uint8List;
      }
    }

    return extractedFiles;
  }
}