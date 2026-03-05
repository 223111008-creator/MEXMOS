import 'package:flutter/material.dart';
import '../../logic/trabajo_logic.dart';

class DrawerEdicionPlaceholder extends StatelessWidget {
  final OpcionDrawer opcion;

  const DrawerEdicionPlaceholder({super.key, required this.opcion});

  @override
  Widget build(BuildContext context) {
    String texto;
    switch (opcion) {
      case OpcionDrawer.base:
        texto = 'Opciones de Base (Configuración de color, opacidad)';
        break;
      case OpcionDrawer.grano:
        texto = 'Opciones de Grano (Configuración de tipo, color, densidad)';
        break;
      case OpcionDrawer.capas:
        texto = 'Opciones de Capas (Gestión de Capas de Grano)';
        break;
      case OpcionDrawer.acabado:
        texto = 'Opciones de Acabado (mate, pulido, etc.)';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Center(
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueGrey.shade700,
          ),
        ),
      ),
    );
  }
}