import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';

class MockApiService {
  static Future<DashboardData> fetchDashboardData(int tabIndex) async {
    await Future.delayed(const Duration(seconds: 1));

    switch (tabIndex) {
      case 0:
        return DashboardData(
          kpis: [
            KpiData(title: 'Quilometragem', value: '12.847', unit: 'km', growth: '+ 4,2%', isPositive: true),
            KpiData(title: 'Viagens realizadas', value: '384', unit: 'viagens', growth: '+ 2,8%', isPositive: true),
            KpiData(title: 'Passageiros', value: '18.420', unit: 'pessoas', growth: '+ 6,1%', isPositive: true),
            KpiData(title: 'Receita estimada', value: 'R\$ 92,1 mil', growth: '- 1,3%', isPositive: false),
          ],
          lines: [
            BusLineData(line: '01', route: 'Circular Barcelona', trips: '64', passengers: '3.842', occupancy: 0.82, status: 'Normal'),
            BusLineData(line: '02', route: 'Circular Fundação', trips: '58', passengers: '3.104', occupancy: 0.76, status: 'Normal'),
          ],
          alerts: [
            AlertData(title: 'Atraso acima do esperado', subtitle: 'Linha 03 · veículo 4521', time: 'há 8 min', icon: Icons.access_time_rounded, color: Colors.orange),
          ],
        );
      default:
        return DashboardData(kpis: [], lines: [], alerts: []);
    }
  }
}