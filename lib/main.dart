import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEMOB SCS - Dashboard de Operação',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F2133),
          primary: const Color(0xFF0F2133),
          secondary: const Color(0xFF00BFA5),
        ),
        useMaterial3: true,
      ),
      home: const DashboardMainScreen(),
    );
  }
}

class DashboardMainScreen extends StatefulWidget {
  const DashboardMainScreen({super.key});

  @override
  State<DashboardMainScreen> createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  int _selectedIndex = 0;

  final List<String> _menuTitles = [
    'Visão geral',
    'Operação',
    'Passageiros',
    'Financeiro',
    'Alertas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildCurrentTabContent(),
                  ),
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
      width: 250,
      color: const Color(0xFF0F2133),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFA5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions_bus, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SEMOB SCS',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Mobilidade Urbana',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MENU PRINCIPAL',
                style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildNavItem(0, Icons.grid_view_rounded, 'Visão geral'),
          _buildNavItem(1, Icons.alt_route_rounded, 'Operação'),
          _buildNavItem(2, Icons.people_outline_rounded, 'Passageiros'),
          _buildNavItem(3, Icons.account_balance_wallet_outlined, 'Financeiro'),
          _buildNavItem(4, Icons.warning_amber_rounded, 'Alertas', badge: '3'),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00BFA5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dados atualizados', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Hoje, 14:32\nFonte: Smart Data', style: TextStyle(color: Colors.white54, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF00BFA5).withOpacity(0.2),
                  child: const Text('MS', style: TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Marina Santos', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text('Gestora de mobilidade', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {String? badge}) {
    final bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? const Color(0xFF00BFA5) : Colors.white70, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _menuTitles[_selectedIndex],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const Text(
                'Acompanhe os principais indicadores do transporte municipal',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 240,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Buscar linha ou veículo',
                hintStyle: TextStyle(fontSize: 12, color: Colors.black38),
                prefixIcon: Icon(Icons.search, size: 18, color: Colors.black45),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F2133),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('Exportar relatório', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildVisaoGeralTab();
      case 1:
        return _buildOperacaoTab();
      case 2:
        return _buildPassageirosTab();
      case 3:
        return _buildFinanceiroTab();
      case 4:
        return _buildAlertasTab();
      default:
        return _buildVisaoGeralTab();
    }
  }

  Widget _buildVisaoGeralTab() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildFilterPill('Hoje', isSelected: true),
                  _buildFilterPill('7 dias'),
                  _buildFilterPill('30 dias'),
                  _buildFilterPill('Personalizado'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: Colors.black54),
                  SizedBox(width: 8),
                  Text('12 de setembro de 2026', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildKpiCard('Quilometragem', '12.847', unit: 'km', growth: '+ 4,2%', isPositive: true, icon: Icons.loop_rounded)),
            const SizedBox(width: 16),
            Expanded(child: _buildKpiCard('Viagens realizadas', '384', unit: 'viagens', growth: '+ 2,8%', isPositive: true, icon: Icons.directions_bus_outlined)),
            const SizedBox(width: 16),
            Expanded(child: _buildKpiCard('Passageiros', '18.420', unit: 'pessoas', growth: '+ 6,1%', isPositive: true, icon: Icons.people_outline)),
            const SizedBox(width: 16),
            Expanded(child: _buildKpiCard('Receita estimada', 'R\$ 92,1 mil', growth: '- 1,3%', isPositive: false, icon: Icons.account_balance_wallet_outlined)),
          ],
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
            Expanded(flex: 2, child: _buildLinePerformanceTable()),
            const SizedBox(width: 16),
            Expanded(flex: 1, child: _buildAlertsListCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildOperacaoTab() {
    return Column(
      children: [
        _buildHeroBanner('SEMOB · CONTROLE OPERACIONAL', 'Operação em tempo real', 'Acompanhe viagens, pontualidade e localização da frota municipal.'),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildSimpleKpiCard('96% de pontualidade', 'Atualizado há poucos minutos', Icons.grid_view_rounded)),
            const SizedBox(width: 16),
            Expanded(child: _buildSimpleKpiCard('42 veículos ativos', 'Atualizado há poucos minutos', Icons.directions_bus_outlined)),
            const SizedBox(width: 16),
            Expanded(child: _buildSimpleKpiCard('384 viagens concluídas', 'Atualizado há poucos minutos', Icons.keyboard_arrow_up_rounded)),
          ],
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
        _buildLinePerformanceTable(),
      ],
    );
  }

  Widget _buildPassageirosTab() {
    return Column(
      children: [
        _buildHeroBanner('SEMOB · CONTROLE OPERACIONAL', 'Análise de demanda', 'Entenda o volume e o perfil dos passageiros por linha e horário.'),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildSimpleKpiCard('18.420 passageiros', 'Atualizado há poucos minutos', Icons.grid_view_rounded)),
            const SizedBox(width: 16),
            Expanded(child: _buildSimpleKpiCard('62% pagantes', 'Atualizado há poucos minutos', Icons.directions_bus_outlined)),
            const SizedBox(width: 16),
            Expanded(child: _buildSimpleKpiCard('Pico às 17:40', 'Atualizado há poucos minutos', Icons.keyboard_arrow_up_rounded)),
          ],
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
        _buildLinePerformanceTable(),
      ],
    );
  }

  Widget _buildFinanceiroTab() {
    return Column(
      children: [
        _buildHeroBanner('SEMOB · CONTROLE OPERACIONAL', 'Visão financeira', 'Receitas estimadas, gratuidades e evolução da arrecadação.'),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildSimpleKpiCard('R\$ 92,1 mil arrecadados', 'Atualizado há poucos minutos', Icons.grid_view_rounded)),
            const SizedBox(width: 16),
            Expanded(child: _buildSimpleKpiCard('R\$ 5,00 tarifa média', 'Atualizado há poucos minutos', Icons.directions_bus_outlined)),
            const SizedBox(width: 16),
            Expanded(child: _buildSimpleKpiCard('4,8% acima da média', 'Atualizado há poucos minutos', Icons.keyboard_arrow_up_rounded)),
          ],
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
        _buildLinePerformanceTable(),
      ],
    );
  }

  Widget _buildAlertasTab() {
    return Column(
      children: [
        _buildHeroBanner('SEMOB · CONTROLE OPERACIONAL', 'Central de alertas', 'Monitore desvios operacionais e acompanhe a resolução de ocorrências.'),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildSimpleKpiCard('3 alertas ativos', 'Atualizado há poucos minutos', Icons.grid_view_rounded)),
            const SizedBox(width: 16),
            Expanded(child: _buildSimpleKpiCard('1 crítico', 'Atualizado há poucos minutos', Icons.directions_bus_outlined)),
            const SizedBox(width: 16),
            Expanded(child: _buildSimpleKpiCard('12 resolvidos hoje', 'Atualizado há poucos minutos', Icons.keyboard_arrow_up_rounded)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildLineChartCard()),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildAlertsListCard(),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Gerenciar alertas', style: TextStyle(color: Colors.black87)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildLinePerformanceTable(),
      ],
    );
  }

  Widget _buildHeroBanner(String category, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2133),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: const TextStyle(color: Color(0xFF00BFA5), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFF0F2133) : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, {String? unit, required String growth, required bool isPositive, required IconData icon}) {
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
                child: Icon(icon, color: const Color(0xFF0284C7), size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  growth,
                  style: TextStyle(
                    color: isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F2133))),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(unit, style: const TextStyle(fontSize: 12, color: Colors.black45)),
              ]
            ],
          ),
          const SizedBox(height: 8),
          const Text('comparado ao período anterior', style: TextStyle(fontSize: 10, color: Colors.black38)),
        ],
      ),
    );
  }

  Widget _buildSimpleKpiCard(String title, String subtitle, IconData icon) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: const Color(0xFF00BFA5), size: 18),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F2133))),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black38)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Movimento da operação', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2133))),
                  Text('Passageiros transportados nos últimos 7 dias', style: TextStyle(fontSize: 11, color: Colors.black45)),
                ],
              ),
              Row(
                children: [
                  _buildChartLegend(const Color(0xFF00BFA5), 'Passageiros'),
                  const SizedBox(width: 12),
                  _buildChartLegend(Colors.black26, 'Média'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomPaint(
              painter: LineChartPainter(),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Seg', style: TextStyle(fontSize: 11, color: Colors.black45)),
              Text('Ter', style: TextStyle(fontSize: 11, color: Colors.black45)),
              Text('Qua', style: TextStyle(fontSize: 11, color: Colors.black45)),
              Text('Qui', style: TextStyle(fontSize: 11, color: Colors.black45)),
              Text('Sex', style: TextStyle(fontSize: 11, color: Colors.black45)),
              Text('Sáb', style: TextStyle(fontSize: 11, color: Colors.black45)),
              Text('Dom', style: TextStyle(fontSize: 11, color: Colors.black45)),
            ],
          )
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
                  CustomPaint(
                    size: const Size(140, 140),
                    painter: DonutChartPainter(),
                  ),
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
          const SizedBox(height: 20),
          _buildDonutLegend(const Color(0xFF00BFA5), 'Pagantes', '62%'),
          _buildDonutLegend(const Color(0xFF0284C7), 'Gratuidades', '22%'),
          _buildDonutLegend(const Color(0xFFF59E0B), 'Estudantes', '16%'),
        ],
      ),
    );
  }

  Widget _buildLinePerformanceTable() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Desempenho por linha', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2133))),
                  Text('Indicadores consolidados do dia', style: TextStyle(fontSize: 11, color: Colors.black45)),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Text('Ver todas', style: TextStyle(color: Color(0xFF00BFA5), fontSize: 12)),
                    Icon(Icons.chevron_right, size: 16, color: Color(0xFF00BFA5)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Table(
            columnWidths: const {
              0: FixedColumnWidth(60),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1.5),
              5: FlexColumnWidth(1),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('LINHA', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('ITINERÁRIO', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('VIAGENS', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('PASSAGEIROS', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('OCUPAÇÃO', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('STATUS', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold))),
                ],
              ),
              _buildTableRow('01', 'Circular Barcelona', '64', '3.842', 0.82, 'Normal'),
              _buildTableRow('02', 'Circular Fundação', '58', '3.104', 0.76, 'Normal'),
            ],
          )
        ],
      ),
    );
  }

  TableRow _buildTableRow(String line, String route, String trips, String passengers, double occupancy, String status) {
    return TableRow(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(line, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(route, style: const TextStyle(fontSize: 12))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(trips, style: const TextStyle(fontSize: 12))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(passengers, style: const TextStyle(fontSize: 12))),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: occupancy,
                  backgroundColor: Colors.black12,
                  color: const Color(0xFF00BFA5),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Text('${(occupancy * 100).toInt()}%', style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(10)),
            child: Text(status, style: const TextStyle(color: Color(0xFF16A34A), fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsListCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Alertas recentes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2133))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(10)),
                child: const Text('3 novos', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAlertItem('Atraso acima do esperado', 'Linha 03 · veículo 4521', 'há 8 min', Icons.access_time_rounded, Colors.orange),
          const Divider(),
          _buildAlertItem('Ocupação elevada', 'Linha 01 · sentido Centro', 'há 21 min', Icons.people_outline, Colors.redAccent),
          const Divider(),
          _buildAlertItem('Operação normalizada', 'Linha 04 · Av. Goiás', 'há 47 min', Icons.check_circle_outline, Colors.green),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String sub, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 10, color: Colors.black38)),
        ],
      ),
    );
  }

  Widget _buildChartLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }

  Widget _buildDonutLegend(Color color, String label, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54))),
          Text(percentage, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFF00BFA5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00BFA5).withOpacity(0.3),
          const Color(0xFF00BFA5).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.cubicTo(size.width * 0.2, size.height * 0.5, size.width * 0.4, size.height * 0.4, size.width * 0.6, size.height * 0.2);
    path.cubicTo(size.width * 0.8, size.height * 0.7, size.width * 0.9, size.height * 0.8, size.width, size.height * 0.9);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 14.0;

    final paint1 = Paint()
      ..color = const Color(0xFF00BFA5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final paint2 = Paint()
      ..color = const Color(0xFF0284C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final paint3 = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -1.5, 3.8, false, paint1);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 2.3, 1.4, false, paint2);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 3.7, 1.0, false, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}