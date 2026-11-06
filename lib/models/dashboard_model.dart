import 'package:flutter/material.dart';

class KpiData {
  final String title;
  final String value;
  final String? unit;
  final String growth;
  final bool isPositive;

  KpiData({
    required this.title,
    required this.value,
    this.unit,
    required this.growth,
    required this.isPositive,
  });
}

class BusLineData {
  final String line;
  final String route;
  final String trips;
  final String passengers;
  final double occupancy;
  final String status;

  BusLineData({
    required this.line,
    required this.route,
    required this.trips,
    required this.passengers,
    required this.occupancy,
    required this.status,
  });
}

class AlertData {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  AlertData({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}

class DashboardData {
  final List<KpiData> kpis;
  final List<BusLineData> lines;
  final List<AlertData> alerts;

  DashboardData({
    required this.kpis,
    required this.lines,
    required this.alerts,
  });
}