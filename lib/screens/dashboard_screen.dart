import 'package:flutter/material.dart';
import '../widgets/top_header_widget.dart';
import '../widgets/sidebar_widget.dart';
import '../widgets/mapa_linhas_dialog.dart';

class DashboardMainScreen extends StatefulWidget {
  const DashboardMainScreen({super.key});

  @override
  State<DashboardMainScreen> createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  Map<String, dynamic>? _dashboardData;
  final List _frotaList = [];
  final List _bilhetesList = [];

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
    _fetchBackendData();
  }

  Future<void> _fetchBackendData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _dashboardData = {
        'totalPassageiros': 0,
        'frotaAtiva': 0,
        'quilometragemDia': 0.0,
      };
      _isLoading = false;
    });
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

  void _importarArquivo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Importar Arquivo Operacional'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Selecione o arquivo de dados (.csv, .xlsx ou .json) enviado pela garagem:'),
            SizedBox(height: 16),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Nenhum arquivo selecionado...',
                suffixIcon: Icon(Icons.attach_file),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pronto para conexão com backend!'),
                  backgroundColor: Color(0xFF003B71),
                ),
              );
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Processar Importação'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003B71),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: const Text(
                    'Uso Interno Operacional',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
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
        return _buildRelatoriosPdfTab();
      case 4:
        return _buildConfiguracoesTab();
      default:
        return _buildVisaoGeralTab();
    }
  }

  Widget _buildVisaoGeralTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Resumo de Indicadores Operacionais', Icons.analytics_outlined),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  'Passageiros Registrados',
                  '${_dashboardData?['totalPassageiros'] ?? 0}',
                  Icons.people_alt_outlined,
                  const Color(0xFF003B71),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  'Veículos em Operação',
                  '${_dashboardData?['frotaAtiva'] ?? 0}',
                  Icons.directions_bus_outlined,
                  const Color(0xFF0066B3),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  'Quilometragem Percorrida',
                  '${_dashboardData?['quilometragemDia'] ?? 0.0} km',
                  Icons.add_road_outlined,
                  const Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('Status de Conexão com o Banco de Dados', Icons.storage_outlined),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const Icon(Icons.cloud_sync_outlined, size: 40, color: Color(0xFF003B71)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Aguardando Integração Backend (MySQL / MongoDB)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Os dados serão atualizados em tempo real assim que as rotas da API forem conectadas.',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _fetchBackendData,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Testar Conexão'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003B71),
                      foregroundColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrotaPassageirosTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('Gestão da Frota de Ônibus', Icons.directions_bus_filled_outlined),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Novo Veículo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003B71),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: _frotaList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.directions_bus_outlined, size: 48, color: Colors.black26),
                        SizedBox(height: 12),
                        Text('Nenhum veículo cadastrado no sistema.', style: TextStyle(color: Colors.black54, fontSize: 15)),
                        Text('Conecte o banco de dados para carregar a lista de frota.', style: TextStyle(color: Colors.black38, fontSize: 13)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _frotaList.length,
                    itemBuilder: (context, index) {
                      final item = _frotaList[index];
                      return ListTile(
                        title: Text('Prefixo: ${item['prefixo']}'),
                        subtitle: Text('Linha: ${item['linha']}'),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTiposBilheteTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Classificação de Tarifas e Bilhetes', Icons.confirmation_number_outlined),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: _bilhetesList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.badge_outlined, size: 48, color: Colors.black26),
                        SizedBox(height: 12),
                        Text('Sem dados de bilhetagem no momento.', style: TextStyle(color: Colors.black54, fontSize: 15)),
                      ],
                    ),
                  )
                : Container(),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatoriosPdfTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Central de Relatórios e Importação de Dados', Icons.folder_open_outlined),
        const SizedBox(height: 16),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestão Operacional de Arquivos da SEMOB',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003B71)),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Utilize os botões abaixo para importar arquivos de diários de bordo ou exportar relatórios consolidados.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _importarArquivo,
                      icon: const Icon(Icons.file_upload_outlined),
                      label: const Text('Importar Arquivo (.CSV / .XLSX)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066B3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gerador de PDF pronto para ser conectado!'),
                            backgroundColor: Color(0xFF003B71),
                          ),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfiguracoesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Configurações de Integração e Servidor', Icons.settings_outlined),
        const SizedBox(height: 16),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Parâmetros da API / Backend',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003B71)),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'URL Base do Backend (API REST)',
                    hintText: 'https://api.semob.saocaetanodosul.sp.gov.br',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}