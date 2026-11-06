import 'package:flutter/material.dart';

class TopHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onRefresh;
  final VoidCallback? onHomePressed;
  final VoidCallback? onMapaCidadePressed;

  const TopHeaderWidget({
    super.key,
    required this.title,
    this.onRefresh,
    this.onHomePressed,
    this.onMapaCidadePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Institucional
          InkWell(
            onTap: onHomePressed,
            child: Row(
              children: [
                const Icon(Icons.location_city_rounded, color: Color(0xFF003B71), size: 36),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'PREFEITURA DE',
                      style: TextStyle(
                        color: Color(0xFF003B71),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'SÃO CAETANO DO SUL',
                      style: TextStyle(
                        color: Color(0xFF003B71),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu de Navegação Simplificado (Interno)
          Row(
            children: [
              // Botão Home
              TextButton.icon(
                onPressed: onHomePressed,
                icon: const Icon(Icons.home_outlined, size: 18, color: Color(0xFF003B71)),
                label: const Text(
                  'Home',
                  style: TextStyle(
                    color: Color(0xFF003B71),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Botão A Cidade (Mapa das Linhas de Ônibus)
              TextButton.icon(
                onPressed: onMapaCidadePressed,
                icon: const Icon(Icons.map_outlined, size: 18, color: Color(0xFF003B71)),
                label: const Text(
                  'A Cidade (Mapa de Linhas)',
                  style: TextStyle(
                    color: Color(0xFF003B71),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),

              if (onRefresh != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF003B71)),
                  tooltip: 'Atualizar Dados',
                  onPressed: onRefresh,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}