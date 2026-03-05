// lib/ui/widgets/drawer_edicion_acabado.dart
import 'package:flutter/material.dart';
import '../../logic/trabajo_logic.dart';

class DrawerEdicionAcabado extends StatelessWidget {
  final TrabajoLogic logic;

  const DrawerEdicionAcabado({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final opciones = ['Mate', 'Pulido Brillante', 'Cepillado', 'Texturizado'];

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Acabado Superficial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: opciones.map((acabado) {
              final isSelected = logic.acabadoSeleccionado == acabado;
              return ChoiceChip(
                label: Text(acabado),
                selected: isSelected,
                onSelected: (_) => logic.actualizarAcabado(acabado),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}