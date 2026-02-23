import 'package:flutter/material.dart';

/// Selector de Colores - Picker accesible con botones de colores
class ColorPicker extends StatefulWidget {
  final List<Color> coloresDisponibles;
  final Color? colorSeleccionadoInicial;
  final ValueChanged<Color> onColorSeleccionado;
  final String etiqueta;
  final String? descripcion;

  const ColorPicker({
    super.key,
    required this.coloresDisponibles,
    this.colorSeleccionadoInicial,
    required this.onColorSeleccionado,
    required this.etiqueta,
    this.descripcion,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _colorSeleccionado;

  @override
  void initState() {
    super.initState();
    _colorSeleccionado =
        widget.colorSeleccionadoInicial ?? widget.coloresDisponibles.first;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: widget.etiqueta,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.etiqueta,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            semanticsLabel: widget.etiqueta,
          ),
          if (widget.descripcion != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.descripcion!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.coloresDisponibles.asMap().entries.map((entry) {
              final index = entry.key;
              final color = entry.value;
              final isSelected = color == _colorSeleccionado;

              return Semantics(
                button: true,
                enabled: true,
                selected: isSelected,
                onTap: () {
                  setState(() {
                    _colorSeleccionado = color;
                  });
                  widget.onColorSeleccionado(color);
                },
                label: 'Color ${index + 1}${isSelected ? ', seleccionado' : ''}',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _colorSeleccionado = color;
                      });
                      widget.onColorSeleccionado(color);
                    },
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 4 : 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
