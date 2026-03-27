// lib/ui/widgets/drawer_edicion_base.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  Future<void> _mostrarDialogoColorPersonalizado(BuildContext context) async {
    Color tempColor = Colors.blue;
    final result = await showDialog<Color>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Configurar Nuevo Pigmento'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: tempColor,
                onColorChanged: (color) {
                  tempColor = color;
                },
                enableAlpha: false,
                displayThumbColor: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar')),
              ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, tempColor),
                  child: const Text('Añadir')),
            ],
          );
        });

    if (result != null) {
      try {
        // Formatear Color a HEX ej. #FFFFFF
        final hexString =
            '#${result.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
        final nuevoPigmento = Pigmento.personalizado(hexString);
        logic.agregarPigmentoPersonalizado(nuevoPigmento);
        logic.seleccionarColorBase(nuevoPigmento);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al crear color.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColorPickerAccesible(
            pigmentosDisponibles: [
              ...pigmentosDisponibles,
              ...logic.pigmentosPersonalizados
            ],
            pigmentoSeleccionado: logic.colorBaseSeleccionado,
            onPigmentoSeleccionado: logic.seleccionarColorBase,
            onAddCustomColor: () => _mostrarDialogoColorPersonalizado(context),
            etiqueta: 'Color de Base',
          ),
          const SizedBox(height: 24),
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
