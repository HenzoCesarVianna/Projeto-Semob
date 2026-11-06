import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'import_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedNavIndex = 0;
  String _selectedPeriod = 'Hoje';
  String _searchQuery = '';

  // Uso de var evita que o parser do editor corte a sintaxe de generics < >
  final List _busLinesData = [
    {
      'codigo': '001',
      'nome': 'Circular Gethsêmani / Estação',
      'passageiros': 3420,
      'gratuidade': 510,
      'receita': 0.0,
      'status': 'Operando',
      'pontualidade': '98%',
      'cor': Colors.blue,
      'coords': const LatLng(-23.6229, -46.5547),
    },
    {
      'codigo': '002',
      'nome': 'Bairro Nova Gérsia / Centro',
      'passageiros': 2890,
      'gratuidade': 420,
      'receita': 0.0,
      'status': 'Operando',
      'pontualidade': '95%',
      'cor': Colors.green,
      'coords': const LatLng(-23.6180, -46.5590),
    },
    {
      'codigo': '003',
      'nome': 'Bairro Santa Maria / Estação',
      'passageiros': 4100,
      'gratuidade': 680,
      'receita': 0.0,
      'status': 'Operando',
      'pontualidade': '92%',
      'cor': Colors.orange,
      'coords': const LatLng(-23.6280, -46.5650),
    },
    {
      'codigo': '004',
      'nome': 'Bairro Barcelona / Fundação',
      'passageiros': 1950,
      'gratuidade': 310,
      'receita': 0.0,
      'status': 'Alerta',
      'pontualidade': '87%',
      'cor': Colors.red,
      'coords': const LatLng(-23.6130, -46.5490),
    },
    {
      'codigo': '005',
      'nome': 'Bairro Prosperidade / Estação',
      'passageiros': 1520,
      'gratuidade': 230,
      'receita': 0.0,
      'status': 'Operando',
      'pontualidade': '96%',
      'cor': Colors.purple,
      'coords': const LatLng(-23.6080, -46.5610),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: _selectedNavIndex == 2
                      ? const ImportTab()
                      : _buildDashboardContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      color: const Color(0xFF0F172A),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions_bus_filled, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SEMOB',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'São Caetano do Sul',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSidebarNavItem(
            index: 0,
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            label: 'Visão Geral',
          ),
          _buildSidebarNavItem(
            index: 1,
            icon: Icons.map_outlined,
            selectedIcon: Icons.map,
            label: 'Mapa de Linhas',
          ),
          _buildSidebarNavItem(
            index: 2,
            icon: Icons.cloud_upload_outlined,
            selectedIcon: Icons.cloud_upload,
            label: 'Importar Relatórios',
          ),
          _buildSidebarNavItem(
            index: 3,
            icon: Icons.analytics_outlined,
            selectedIcon: Icons.analytics,
            label: 'Relatórios & Métricas',
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF0284C7),
                  radius: 18,
                  child: Text('SC', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gestor SEMOB', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      Text('Prefeitura de SCS', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final isSelected = _selectedNavIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          tileColor: isSelected ? const Color(0xFF0284C7) : Colors.transparent,
          leading: Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            size: 20,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedNavIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedNavIndex == 2 ? 'Importação de Dados' : 'Painel de Controle Operacional',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Text(
                'Sistema de Gestão do Transporte Público Municipal',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriod,
                isDense: true,
                items: ['Hoje', 'Esta Semana', 'Este Mês', 'Setembro 2026', 'Agosto 2026']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPeriod = val);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF64748B)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricsGrid(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _buildMapCard(),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: _buildChartCard(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildBusLinesTable(),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final numberFormatter = NumberFormat.decimalPattern('pt_BR');

    int totalPassageiros = _busLinesData.fold(0, (sum, item) => sum + ((item['passageiros'] as int?) ?? 0));
    int totalGratuidade = _busLinesData.fold(0, (sum, item) => sum + ((item['gratuidade'] as int?) ?? 0));
    double receitaTotal = _busLinesData.fold(0.0, (sum, item) => sum + ((item['receita'] as double?) ?? 0.0));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.1,
          children: [
            _buildKpiCard(
              title: 'Total Passageiros',
              value: numberFormatter.format(totalPassageiros),
              icon: Icons.people_outline,
              color: const Color(0xFF0284C7),
              subtext: '+4.2% em relação a ontem',
            ),
            _buildKpiCard(
              title: 'Gratuidade / Isenções',
              value: numberFormatter.format(totalGratuidade),
              icon: Icons.card_membership_outlined,
              color: const Color(0xFFD97706),
              subtext: '16.5% do total transportado',
            ),
            _buildKpiCard(
              title: 'Receita Tarifária',
              value: currencyFormatter.format(receitaTotal),
              icon: Icons.attach_money,
              color: const Color(0xFF16A34A),
              subtext: 'Programa Tarifa Zero SCS',
            ),
            _buildKpiCard(
              title: 'Pontualidade Média',
              value: '94.8%',
              icon: Icons.access_time_outlined,
              color: const Color(0xFF8B5CF6),
              subtext: '5 linhas ativas na rede',
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtext,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(subtext, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Geolocalização das Linhas de São Caetano do Sul',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                Icon(Icons.map_outlined, color: Color(0xFF0284C7), size: 20),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(-23.6229, -46.5547),
                  initialZoom: 13.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.semob.saocaetano',
                  ),
                  MarkerLayer(
                    markers: _busLinesData.map((line) {
                      return Marker(
                        point: line['coords'] as LatLng,
                        width: 40,
                        height: 40,
                        child: Tooltip(
                          message: '${line['codigo']} - ${line['nome']}',
                          child: Container(
                            decoration: BoxDecoration(
                              color: line['cor'] as Color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.directions_bus, color: Colors.white, size: 20),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      height: 380,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Volume de Passageiros por Linha',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          const Text('Comparativo diário das linhas operacionais', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 5000,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        final index = val.toInt();
                        if (index >= 0 && index < _busLinesData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'L${_busLinesData[index]['codigo']}',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
                barGroups: List.generate(_busLinesData.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: ((_busLinesData[i]['passageiros'] as int?) ?? 0).toDouble(),
                        color: _busLinesData[i]['cor'] as Color,
                        width: 22,
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
    );
  }

  Widget _buildBusLinesTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detalhamento das Linhas Municipais',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                SizedBox(
                  width: 240,
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar linha...',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          DataTable(
            columns: const [
              DataColumn(label: Text('Código')),
              DataColumn(label: Text('Linha')),
              DataColumn(label: Text('Passageiros')),
              DataColumn(label: Text('Gratuidade')),
              DataColumn(label: Text('Pontualidade')),
              DataColumn(label: Text('Status')),
            ],
            rows: _busLinesData.where((line) {
              final query = _searchQuery.toLowerCase();
              return line['codigo'].toString().toLowerCase().contains(query) ||
                     line['nome'].toString().toLowerCase().contains(query);
            }).map((line) {
              return DataRow(
                cells: [
                  DataCell(Text(line['codigo'].toString(), style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(line['nome'].toString())),
                  DataCell(Text(line['passageiros'].toString())),
                  DataCell(Text(line['gratuidade'].toString())),
                  DataCell(Text(line['pontualidade'].toString())),
                  DataCell(
                    Chip(
                      label: Text(line['status'].toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
                      backgroundColor: line['status'] == 'Operando' ? Colors.green : Colors.orange,
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
}