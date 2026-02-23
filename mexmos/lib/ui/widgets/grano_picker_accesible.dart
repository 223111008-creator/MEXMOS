import 'package:flutter/material.dart';
// ¡Se agregó un ../ extra!
import '../../../domain/models/grano_marmol.dart';
import '../../../domain/services/transformador_color.dart';

class GranoPickerAccesible extends StatelessWidget {
  final List<GranoMarmol> granosDisponibles;
  final GranoMarmol? granoSeleccionado;
  final Function(GranoMarmol) onGranoSeleccionado;
  final String etiqueta;
  final String modoDaltonismo;

  const GranoPickerAccesible({
    super.key,
    required this.granosDisponibles,
    required this.granoSeleccionado,
    required this.onGranoSeleccionado,
    required this.etiqueta,
    this.modoDaltonismo = 'Normal',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: granosDisponibles.map((grano) {
            final isSelected = grano.id == granoSeleccionado?.id;
            final colorOriginal = Color(grano.colorNatural | 0xFF000000); 
            final colorMostrado = TransformadorColor.aplicarFiltro(colorOriginal, modoDaltonismo);

            return Semantics(
              label: 'Grano ${grano.nombre}, tamaño ${grano.codigoTamano}',
              selected: isSelected,
              button: true,
              child: InkWell(
                onTap: () => onGranoSeleccionado(grano),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade50 : Colors.white,
                    border: isSelected
                        ? Border.all(color: Colors.blue.shade800, width: 2.0)
                        : Border.all(color: Colors.grey.shade300, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colorMostrado,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              grano.nombre,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              grano.codigoTamano,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}