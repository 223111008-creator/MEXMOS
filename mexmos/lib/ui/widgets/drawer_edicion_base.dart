// lib/ui/widgets/drawer_edicion_base.dart
import 'package:flutter/material.dart';
import '../../domain/models/pigmento.dart';
import '../../logic/trabajo_logic.dart';

import 'color_picker_accesible.dart';

class DrawerEdicionBase extends StatelessWidget {
  final TrabajoLogic logic;
  final List<Pigmento> pigmentosDisponibles;

  const DrawerEdicionBase({
    super.key,
    required this.logic,
    required this.pigmentosDisponibles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColorPickerAccesible(
            pigmentosDisponibles: pigmentosDisponibles,
            pigmentoSeleccionado: logic.colorBaseSeleccionado,
            onPigmentoSeleccionado: logic.seleccionarColorBase,
            etiqueta: 'Color de Base',
          ),
          const Spacer(),
          const Text('Opacidad', style: TextStyle(fontWeight: FontWeight.bold)),
          Semantics(
            slider: true,
            label: 'Ajustar opacidad de la base',
            child: Slider(
              value: logic.opacidadBase,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: '${(logic.opacidadBase * 100).round()}%',
              onChanged: logic.actualizarOpacidadBase,
            ),
          ),
        ],
      ),
    );
  }
}
