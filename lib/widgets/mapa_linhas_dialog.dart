import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapaLinhasDialog extends StatelessWidget {
  const MapaLinhasDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MapaLinhasDialogContent();
  }
}

class _MapaLinhasDialogContent extends StatefulWidget {
  const _MapaLinhasDialogContent();

  @override
  State<_MapaLinhasDialogContent> createState() => _MapaLinhasDialogContentState();
}

class _MapaLinhasDialogContentState extends State<_MapaLinhasDialogContent> {
  final TransformationController _transformationController = TransformationController();
  final FocusNode _focusNode = FocusNode();
  bool _isCtrlPressed = false;

  @override
  void dispose() {
    _transformationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        final isCtrl = event.isControlPressed;
        if (_isCtrlPressed != isCtrl) {
          setState(() {
            _isCtrlPressed = isCtrl;
          });
        }
      },
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          color: const Color(0xFF003B71),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.map_outlined, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Mapa Oficial dos Itinerários - SEMOB / VIPE',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        titlePadding: EdgeInsets.zero,
        content: SizedBox(
          width: screenSize.width * 0.90,
          height: screenSize.height * 0.82,
          child: Column(
            children: [
              // Barra de Instruções e Ferramentas
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color(0xFFF4F6F9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.mouse_outlined, size: 16, color: Color(0xFF003B71)),
                        SizedBox(width: 6),
                        Text(
                          'Clique e arraste para navegar | ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF003B71)),
                        ),
                        Text(
                          'Segure Ctrl + Scroll para dar Zoom',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: _resetZoom,
                      icon: const Icon(Icons.restart_alt, size: 16, color: Color(0xFF003B71)),
                      label: const Text('Resetar Visão', style: TextStyle(fontSize: 12, color: Color(0xFF003B71))),
                    ),
                  ],
                ),
              ),

              // Área do Mapa com Arraste por Clique e Zoom via Ctrl+Scroll
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    panEnabled: true, // Permite clicar e arrastar a imagem livremente
                    scaleEnabled: _isCtrlPressed, // Ativa o zoom por scroll/pinch somente ao segurar Ctrl
                    boundaryMargin: const EdgeInsets.all(500),
                    minScale: 1.0,
                    maxScale: 5.0,
                    child: Center(
                      child: Image.asset(
                        'assets/mapa_linhas.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'Erro ao carregar mapa_linhas.png',
                                style: TextStyle(color: Color(0xFF003B71)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('Fechar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003B71),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}