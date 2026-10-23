import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import '../services/mock_api_service.dart';
import '../widgets/sidebar_widget.dart';
import '../widgets/top_header_widget.dart';
import '../widgets/charts_widgets.dart';

class DashboardMainScreen extends StatefulWidget {
  const DashboardMainScreen({super.key});

  @override
  State<DashboardMainScreen> createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  int _selectedIndex = 0;
  late Future<DashboardData> _dashboardDataFuture;

  final List<String> _menuTitles = [
    'Visão geral',
    'Operação',
    'Passageiros',
    'Financeiro',
    'Alertas',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _dashboardDataFuture = MockApiService.fetchDashboardData(_selectedIndex);
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarWidget(
            selectedIndex: _selectedIndex,
            onTabSelected: _onTabSelected,
          ),
          Expanded(
            child: Column(
              children: [
                TopHeaderWidget(
                  title: _menuTitles[_selectedIndex],
                  onRefresh: _loadData,
                ),
                Expanded(
                  child: FutureBuilder<DashboardData>(
                    future: _dashboardDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erro ao carregar os dados: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: _buildDashboardContent(snapshot.data!),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(DashboardData data) {
    return Column(
      children: [
        Row(
          children: data.kpis.map((kpi) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: _buildKpiCard(kpi),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildLineChartCard()),
            const SizedBox(width: 16),
            Expanded(flex: 1, child: _buildDonutChartCard()),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildLinePerformanceTable(data.lines)),
            const SizedBox(width: 16),
            Expanded(flex: 1, child: _buildAlertsListCard(data.alerts)),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard(KpiData kpi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.analytics_outlined, color: Color(0xFF0284C7), size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kpi.isPositive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  kpi.growth,
                  style: TextStyle(
                    color: kpi.isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(kpi.title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(kpi.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F2133))),
              if (kpi.unit != null) ...[
                const SizedBox(width: 4),
                Text(kpi.unit!, style: const TextStyle(fontSize: 12, color: Colors.black45)),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Movimento da operação', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2133))),
          const Text('Passageiros transportados nos últimos 7 dias', style: TextStyle(fontSize: 11, color: Colors.black45)),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomPaint(painter: LineChartPainter()),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Perfil de passageiros', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2133))),
          const Text('Distribuição por categoria', style: TextStyle(fontSize: 11, color: Colors.black45)),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: 140,
              width: 140,
              child: Stack(
                children: [
                  CustomPaint(size: const Size(140, 140), painter: DonutChartPainter()),
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('18.420', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('total', style: TextStyle(fontSize: 10, color: Colors.black45)),
                      ],
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

  Widget _buildLinePerformanceTable(List<BusLineData> lines) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Desempenho por linha', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2133))),
          const SizedBox(height: 12),
          Table(
            columnWidths: const {
              0: FixedColumnWidth(60),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('LINHA', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('ITINERÁRIO', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('VIAGENS', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('PASSAGEIROS', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                ],
              ),
              ...lines.map((line) => TableRow(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
                children: [
                  Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(line.line, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(line.route, style: const TextStyle(fontSize: 12))),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(line.trips, style: const TextStyle(fontSize: 12))),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(line.passengers, style: const TextStyle(fontSize: 12))),
                ],
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAlertsListCard(List<AlertData> alerts) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Alertas recentes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2133))),
          const SizedBox(height: 12),
          ...alerts.map((alert) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(alert.icon, color: alert.color, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alert.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(alert.subtitle, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                    ],
                  ),
                ),
                Text(alert.time, style: const TextStyle(fontSize: 10, color: Colors.black38)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}