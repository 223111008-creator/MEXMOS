import 'package:flutter/material.dart';
import '../../logic/trabajo_logic.dart';

class DrawerEdicionAcabado extends StatelessWidget {
  final TrabajoLogic logic;

  const DrawerEdicionAcabado({
    super.key,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    const acabadosDisponibles = ['Mate', 'Pulido', 'Texturizado'];

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Acabado Final',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: acabadosDisponibles.map((acabado) {
              final isSelected = logic.acabadoSeleccionado == acabado;
              return Semantics(
                label: 'Acabado $acabado',
                selected: isSelected,
                button: true,
                child: ChoiceChip(
                  label: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(acabado, style: const TextStyle(fontSize: 16)),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      logic.actualizarAcabado(acabado);
                    }
                  },
                  selectedColor: Colors.blue.shade100,
                  labelStyle: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue.shade900 : Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          const Text(
            'El acabado define el proceso final de pulido o texturizado tras el fraguado.',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }
}
