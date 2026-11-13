import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../widgets/top_header_widget.dart';
import '../widgets/sidebar_widget.dart';
import '../widgets/mapa_linhas_dialog.dart';
import '../models/semob_report_models.dart';
import '../services/semob_repository.dart';
import '../services/semob_pdf_service.dart';
import 'import_tab.dart';

class DashboardMainScreen extends StatefulWidget {
  const DashboardMainScreen({super.key});

  @override
  State<DashboardMainScreen> createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  final SemobRepository _repository = SemobRepository.instance;
  final TextEditingController _apiUrlController = TextEditingController();

  int _selectedIndex = 0;
  bool _isLoading = false;
  bool _isTestingConnection = false;
  String _selectedPeriod = 'Hoje';
  String _searchQuery = '';
  List<PassengerReportRecord> _linesData = [];

  final List<String> _menuTitles = [
    'Painel de Controle - Visão Geral',
    'Gestão de Frota e Passageiros',
    'Categorias e Tipos de Bilhete',
    'Geração e Importação de Relatórios',
    'Configurações do Sistema',
  ];

  @override
  void initState() {
    super.initState();
    _apiUrlController.text = _repository.baseUrl;
    _fetchBackendData();
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    super.dispose();
  }

  Future<void> _fetchBackendData() async {
    setState(() => _isLoading = true);
    final data = await _repository.getLinesData(period: _selectedPeriod);
    if (mounted) {
      setState(() {
        _linesData = data;
        _isLoading = false;
      });
    }
  }

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _goHome() {
    setState(() => _selectedIndex = 0);
  }

  void _mostrarMapaLinhasCidade() {
    showDialog(
      context: context,
      builder: (context) => const MapaLinhasDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Column(
        children: [
          TopHeaderWidget(
            title: _menuTitles[_selectedIndex],
            onRefresh: _fetchBackendData,
            onHomePressed: _goHome,
            onMapaCidadePressed: _mostrarMapaLinhasCidade,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            color: const Color(0xFF1B365D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SEMOB - Secretaria De Mobilidade Urbana',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPeriod,
                          isDense: true,
                          iconEnabledColor: const Color(0xFF003B71),
                          style: const TextStyle(
                            color: Color(0xFF003B71),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          items: ['Hoje', 'Esta Semana', 'Este Mês', 'Setembro 2026', 'Agosto 2026']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedPeriod = val);
                              _fetchBackendData();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: _repository.useBackendApi ? Colors.greenAccent : const Color(0xFFFFC72C),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _repository.useBackendApi ? 'API Conectada' : 'Aguardando Banco de Dados',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SidebarWidget(
                  selectedIndex: _selectedIndex,
                  onTabSelected: _onTabSelected,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003B71)),
                            ),
                          )
                        : _buildSelectedTabContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildVisaoGeralTab();
      case 1:
        return _buildFrotaPassageirosTab();
      case 2:
        return _buildTiposBilheteTab();
      case 3:
        return _buildRelatoriosImportacaoTab();
      case 4:
        return _buildConfiguracoesTab();
      default:
        return _buildVisaoGeralTab();
    }
  }

  Widget _buildVisaoGeralTab() {
    final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final numberFormatter = NumberFormat.decimalPattern('pt_BR');

    int totalPassageiros = _linesData.fold(0, (sum, item) => sum + item.totalPassageiros);
    int totalGratuidade = _linesData.fold(0, (sum, item) => sum + item.gratuidade);
    double receitaTotal = _linesData.fold(0.0, (sum, item) => sum + item.valorTotal);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Resumo de Indicadores Operacionais ($_selectedPeriod)', Icons.analytics_outlined),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  'Total de Passageiros',
                  numberFormatter.format(totalPassageiros),
                  Icons.people_alt_outlined,
                  const Color(0xFF003B71),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  'Gratuidade / Isenções',
                  numberFormatter.format(totalGratuidade),
                  Icons.card_membership_outlined,
                  const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  'Receita Tarifária',
                  currencyFormatter.format(receitaTotal),
                  Icons.attach_money_outlined,
                  const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  'Linhas Monitoradas',
                  '${_linesData.length} linhas',
                  Icons.directions_bus_outlined,
                  const Color(0xFF0066B3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildChartCard(),
          const SizedBox(height: 24),
          _buildBusLinesTableCard(),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    double maxVal = 100;
    for (final l in _linesData) {
      if (l.totalPassageiros > maxVal) maxVal = l.totalPassageiros.toDouble() * 1.15;
    }

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        height: 320,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.bar_chart, color: Color(0xFF003B71), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Volume de Passageiros por Linha',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003B71)),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _mostrarMapaLinhasCidade,
                  icon: const Icon(Icons.map_outlined, size: 16, color: Color(0xFF003B71)),
                  label: const Text('Ver Mapa Oficial de Linhas', style: TextStyle(fontSize: 12, color: Color(0xFF003B71))),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text('Comparativo operacional da rede municipal', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 24),
            Expanded(
              child: _linesData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.insert_chart_outlined, size: 48, color: Colors.black26),
                          const SizedBox(height: 12),
                          const Text(
                            'Nenhum dado operacional carregado.',
                            style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          TextButton.icon(
                            onPressed: () => _onTabSelected(3),
                            icon: const Icon(Icons.upload_file, size: 16, color: Color(0xFF003B71)),
                            label: const Text(
                              'Importar relatórios (.ZIP / .HTML / .XLSX) ou conectar banco de dados',
                              style: TextStyle(color: Color(0xFF003B71), fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxVal,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) {
                                final index = val.toInt();
                                if (index >= 0 && index < _linesData.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Linha ${_linesData[index].linha}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF003B71),
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(_linesData.length, (i) {
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: _linesData[i].totalPassageiros.toDouble(),
                                color: _linesData[i].badgeColor,
                                width: 32,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusLinesTableCard() {
    final filteredLines = _linesData.where((line) {
      final query = _searchQuery.toLowerCase();
      return line.linha.toLowerCase().contains(query) || line.nomeLinha.toLowerCase().contains(query);
    }).toList();

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('Detalhamento das Linhas Municipais', Icons.list_alt_outlined),
                SizedBox(
                  width: 260,
                  height: 38,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Filtrar por código ou bairro...',
                      prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF003B71)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (filteredLines.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                children: [
                  Icon(Icons.directions_bus_outlined, size: 42, color: Colors.black26),
                  SizedBox(height: 10),
                  Text(
                    'Nenhuma linha registrada no banco de dados.',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Importe os relatórios da garagem ou conecte o servidor na aba Configurações.',
                    style: TextStyle(color: Colors.black38, fontSize: 12),
                  ),
                ],
              ),
            )
          else
            DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF4F6F9)),
              columns: const [
                DataColumn(label: Text('Código', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003B71)))),
                DataColumn(label: Text('Linha / Itinerário', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003B71)))),
                DataColumn(label: Text('Passageiros', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003B71)))),
                DataColumn(label: Text('Gratuidade', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003B71)))),
                DataColumn(label: Text('Pontualidade', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003B71)))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003B71)))),
              ],
              rows: filteredLines.map((line) {
                return DataRow(
                  cells: [
                    DataCell(Text(line.linha, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(line.nomeLinha.isEmpty ? 'Linha Municipal ${line.linha}' : line.nomeLinha)),
                    DataCell(Text(line.totalPassageiros.toString())),
                    DataCell(Text(line.gratuidade.toString())),
                    DataCell(Text(line.pontualidade)),
                    DataCell(
                      Chip(
                        label: Text(
                          line.status,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: line.status == 'Operando' ? const Color(0xFF2E7D32) : const Color(0xFFD97706),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildFrotaPassageirosTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Gestão da Frota e Linhas em Operação', Icons.directions_bus_filled_outlined),
          const SizedBox(height: 16),
          _buildBusLinesTableCard(),
        ],
      ),
    );
  }

  Widget _buildTiposBilheteTab() {
    int totalPassageiros = _linesData.fold(0, (sum, item) => sum + item.totalPassageiros);
    int totalGratuidade = _linesData.fold(0, (sum, item) => sum + item.gratuidade);
    int tarifaZeroComum = totalPassageiros - totalGratuidade;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Classificação de Tarifas e Bilhetes (Programa Tarifa Zero)', Icons.confirmation_number_outlined),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  'Cartão Cidadão / Tarifa Zero',
                  '$tarifaZeroComum embarques',
                  Icons.credit_card,
                  const Color(0xFF003B71),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  'Gratuidade (Idosos / PcD / Estudantes)',
                  '$totalGratuidade embarques',
                  Icons.accessible_forward,
                  const Color(0xFFD97706),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelatoriosImportacaoTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Central de Importação e Relatórios Operacionais', Icons.folder_open_outlined),
          const SizedBox(height: 16),
          ImportTab(
            onImportSuccess: () {
              _fetchBackendData();
            },
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exportação Consolidada em PDF',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF003B71)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Gera o documento oficial da SEMOB com os indicadores e linhas atuais.',
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _linesData.isEmpty
                        ? null
                        : () async {
                            await SemobPdfService.exportOperationalReport(
                              period: _selectedPeriod,
                              lines: _linesData,
                            );
                          },
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Exportar PDF Completo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003B71),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfiguracoesTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Configurações de Integração e Banco de Dados', Icons.settings_outlined),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Conexão com Backend REST (MySQL / MongoDB)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003B71)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enquanto o servidor estiver desligado, o sistema opera em Modo Local mantendo os dados importados na sessão.',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _apiUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL Base do Backend (API REST)',
                      hintText: 'http://localhost:3000/api/semob',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Ativar Sincronização com Backend (API)',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF003B71)),
                    ),
                    subtitle: Text(
                      _repository.useBackendApi
                          ? 'Ativado: Enviando POST e lendo GET do servidor.'
                          : 'Desativado: Operando com repositório local em memória.',
                    ),
                    value: _repository.useBackendApi,
                    activeColor: const Color(0xFF003B71),
                    onChanged: (val) {
                      setState(() {
                        _repository.baseUrl = _apiUrlController.text.trim();
                        _repository.useBackendApi = val;
                      });
                      _fetchBackendData();
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isTestingConnection
                            ? null
                            : () async {
                                setState(() => _isTestingConnection = true);
                                final ok = await _repository.testBackendConnection(_apiUrlController.text);
                                setState(() => _isTestingConnection = false);

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        ok
                                            ? 'Conexão com ${_apiUrlController.text} estabelecida com sucesso!'
                                            : 'Servidor não respondeu em ${_apiUrlController.text}/health. Mantendo Modo Local.',
                                      ),
                                      backgroundColor: ok ? const Color(0xFF2E7D32) : const Color(0xFFD97706),
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.network_check),
                        label: Text(_isTestingConnection ? 'Testando...' : 'Testar Conexão com API'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003B71),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          _repository.clearLocalData();
                          _fetchBackendData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cache local limpo com sucesso.'),
                              backgroundColor: Color(0xFF003B71),
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outline, color: Color(0xFF003B71)),
                        label: const Text('Limpar Cache Local', style: TextStyle(color: Color(0xFF003B71))),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF003B71), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003B71),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(color: color, fontSize: 19, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}