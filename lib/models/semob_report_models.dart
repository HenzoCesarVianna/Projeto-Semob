class ReportFileMetadata {
  final String fileName;
  final String reportType; // 'passageiros', 'saldos', 'linhas', 'viagens', etc.
  final String periodicity; // 'mensal' ou 'quinzenal'
  final String periodReference; // ex: '202608'

  ReportFileMetadata({
    required this.fileName,
    required this.reportType,
    required this.periodicity,
    required this.periodReference,
  });
}

class PassengerReportRecord {
  final String linha;
  final int totalPassageiros;
  final int gratuidade;
  final double valorTotal;

  PassengerReportRecord({
    required this.linha,
    required this.totalPassageiros,
    required this.gratuidade,
    required this.valorTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'linha': linha,
      'totalPassageiros': totalPassageiros,
      'gratuidade': gratuidade,
      'valorTotal': valorTotal,
    };
  }
}