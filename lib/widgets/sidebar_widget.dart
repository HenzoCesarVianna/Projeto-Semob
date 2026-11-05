import 'package:flutter/material.dart';

class SidebarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFF00284D),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 20),
          _buildMenuItem(0, Icons.dashboard_outlined, 'Visão Geral'),
          _buildMenuItem(1, Icons.directions_bus_outlined, 'Frota & Passageiros'),
          _buildMenuItem(2, Icons.confirmation_number_outlined, 'Tipos de Bilhete'),
          _buildMenuItem(3, Icons.picture_as_pdf_outlined, 'Relatórios PDF'),
          const Divider(color: Colors.white24, indent: 16, endIndent: 16),
          _buildMenuItem(4, Icons.settings_outlined, 'Configurações'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFFFC72C) : Colors.white70,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? const Color(0xFF0066B3) : Colors.transparent,
      onTap: () => onTabSelected(index),
    );
  }
}