import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const SemobApp());
}

class SemobApp extends StatelessWidget {
  const SemobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEMOB - São Caetano do Sul',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        primaryColor: const Color(0xFF003B71),
        fontFamily: 'Roboto',
      ),
      home: const DashboardMainScreen(), // Nome correto da classe
    );
  }
}