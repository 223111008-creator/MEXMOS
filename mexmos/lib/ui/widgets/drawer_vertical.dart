import 'package:flutter/material.dart';
import '../../logic/trabajo_logic.dart';

class DrawerVertical extends StatelessWidget {
  final OpcionTrabajo opcionSeleccionada;
  final Function(OpcionTrabajo) onOpcionSeleccionada;

  const DrawerVertical({
    super.key,
    required this.opcionSeleccionada,
    required this.onOpcionSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    // Definir las opciones con ícono y etiqueta
    final opciones = [
      _OpcionItem(icon: Icons.format_paint, label: 'Base', tipo: OpcionTrabajo.base),
      _OpcionItem(icon: Icons.grain, label: 'Grano', tipo: OpcionTrabajo.grano),
      _OpcionItem(icon: Icons.layers, label: 'Capas', tipo: OpcionTrabajo.capas),
      _OpcionItem(icon: Icons.brush, label: 'Acabado', tipo: OpcionTrabajo.acabado),
      _OpcionItem(icon: Icons.visibility, label: 'Vista', tipo: OpcionTrabajo.vista),
    ];

    return Container(
      width: 120, // Ancho fijo del drawer
      color: Colors.grey[100],
      child: ListView.builder(
        itemCount: opciones.length,
        itemBuilder: (context, index) {
          final item = opciones[index];
          final isSelected = opcionSeleccionada == item.tipo;

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onOpcionSeleccionada(item.tipo),
              child: Container(
                height: 90, // Alto del botón
                width: 105, // Ancho del botón (aunque el contenedor padre ya define 120)
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[100] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 32, color: isSelected ? Colors.blue : Colors.grey[700]),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OpcionItem {
  final IconData icon;
  final String label;
  final OpcionTrabajo tipo;
  const _OpcionItem({required this.icon, required this.label, required this.tipo});
}