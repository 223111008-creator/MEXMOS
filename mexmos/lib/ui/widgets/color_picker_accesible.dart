import 'package:flutter/material.dart';
// ¡Se agregó un ../ extra para alcanzar la carpeta domain correctamente!
import '../../../domain/models/pigmento.dart';
import '../../../domain/services/transformador_color.dart';

class ColorPickerAccesible extends StatelessWidget {
  final List<Pigmento> pigmentosDisponibles;
  final Pigmento? pigmentoSeleccionado;
  final Function(Pigmento) onPigmentoSeleccionado;
  final VoidCallback? onAddCustomColor;
  final String etiqueta;
  final String modoDaltonismo;

  const ColorPickerAccesible({
    super.key,
    required this.pigmentosDisponibles,
    required this.pigmentoSeleccionado,
    required this.onPigmentoSeleccionado,
    this.onAddCustomColor,
    required this.etiqueta,
    this.modoDaltonismo = 'Normal',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: pigmentosDisponibles.map((pigmento) {
            final isSelected = pigmento.id == pigmentoSeleccionado?.id;
            final colorOriginal =
                TransformadorColor.hexToColor(pigmento.codigoHex);
            final colorMostrado =
                TransformadorColor.aplicarFiltro(colorOriginal, modoDaltonismo);

            return Semantics(
              label: 'Color ${pigmento.nombreComercial}',
              selected: isSelected,
              button: true,
              child: Tooltip(
                message: pigmento.nombreComercial,
                child: InkWell(
                  onTap: () => onPigmentoSeleccionado(pigmento),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colorMostrado,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 4.0)
                          : Border.all(color: Colors.grey.shade300, width: 1.0),
                      boxShadow: isSelected
                          ? const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2))
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            );
          }).toList()
            ..addAll(onAddCustomColor != null
                ? [
                    Semantics(
                      label: 'Añadir color personalizado',
                      button: true,
                      child: Tooltip(
                        message: 'Añadir código HEX',
                        child: InkWell(
                          onTap: onAddCustomColor,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.grey.shade400, width: 1.0),
                            ),
                            child: const Icon(Icons.add, color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  ]
                : []),
        ),
      ],
    );
  }
}
