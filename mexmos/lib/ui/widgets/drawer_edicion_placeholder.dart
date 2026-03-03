import 'package:flutter/material.dart';
import '../../logic/trabajo_logic.dart';

class DrawerEdicionPlaceholder extends StatelessWidget {
  final OpcionTrabajo opcionSeleccionada;

  const DrawerEdicionPlaceholder({super.key, required this.opcionSeleccionada});

  @override
  Widget build(BuildContext context) {
    String texto = '';
    switch (opcionSeleccionada) {
      case OpcionTrabajo.base:
        texto = 'Aquí irán los controles para la capa base (color, opacidad)';
        break;
      case OpcionTrabajo.grano:
        texto = 'Aquí irán los controles para el grano (tipo, color, densidad)';
        break;
      case OpcionTrabajo.capas:
        texto = 'Aquí irá el gestor de capas de grano';
        break;
      case OpcionTrabajo.acabado:
        texto = 'Aquí irán las opciones de acabado (mate, pulido, etc.)';
        break;
      case OpcionTrabajo.vista:
        texto = 'Aquí irán los controles de vista (zoom, rotación, etc.)';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editando: ${opcionSeleccionada.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(texto),
        ],
      ),
    );
  }
}