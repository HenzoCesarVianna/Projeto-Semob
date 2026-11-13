import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/semob_report_models.dart';

class SemobPdfService {
  static Future<void> exportOperationalReport({
    required String period,
    required List<PassengerReportRecord> lines,
  }) async {
    final pdf = pw.Document();
    final numberFormatter = NumberFormat.decimalPattern('pt_BR');
    final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final nowFormatted = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    final int totalPassageiros = lines.fold(0, (sum, item) => sum + item.totalPassageiros);
    final int totalGratuidade = lines.fold(0, (sum, item) => sum + item.gratuidade);
    final double totalReceita = lines.fold(0.0, (sum, item) => sum + item.valorTotal);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // Cabeçalho Institucional
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            color: PdfColor.fromHex('#003B71'),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'PREFEITURA DE SÃO CAETANO DO SUL',
                      style: pw.TextStyle(color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'SEMOB - Secretaria de Mobilidade Urbana',
                      style: pw.TextStyle(color: PdfColors.white, fontSize: 16, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                pw.Text(
                  'Período: $period',
                  style: const pw.TextStyle(color: PdfColors.white, fontSize: 11),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Resumo de KPIs
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildPdfKpiBox('Total de Passageiros', numberFormatter.format(totalPassageiros)),
              _buildPdfKpiBox('Gratuidade / Isenções', numberFormatter.format(totalGratuidade)),
              _buildPdfKpiBox('Receita Tarifária', currencyFormatter.format(totalReceita)),
            ],
          ),
          pw.SizedBox(height: 24),

          pw.Text(
            'Detalhamento Operacional por Linha',
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#003B71')),
          ),
          pw.SizedBox(height: 8),

          // Tabela de Dados
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10),
            headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#003B71')),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignment: pw.Alignment.centerLeft,
            headers: ['Código', 'Itinerário', 'Passageiros', 'Gratuidade', 'Pontualidade', 'Status'],
            data: lines.map((l) {
              return [
                l.linha,
                l.nomeLinha.isEmpty ? 'Linha ${l.linha}' : l.nomeLinha,
                numberFormatter.format(l.totalPassageiros),
                numberFormatter.format(l.gratuidade),
                l.pontualidade,
                l.status,
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Documento gerado eletronicamente em $nowFormatted - Uso Interno SEMOB.',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Relatorio_SEMOB_${period.replaceAll(' ', '_')}.pdf',
    );
  }

  static pw.Widget _buildPdfKpiBox(String title, String value) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 4),
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#003B71')),
            ),
          ],
        ),
      ),
    );
  }
}