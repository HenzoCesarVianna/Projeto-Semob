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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003B71),
          primary: const Color(0xFF003B71),
        ),
        useMaterial3: true,
      ),
      home: const DashboardMainScreen(),
    );
  }
}