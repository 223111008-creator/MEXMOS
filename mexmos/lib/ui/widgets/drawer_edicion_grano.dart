import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../domain/models/pigmento.dart';
import '../../domain/models/grano_marmol.dart';
import '../../domain/models/capa_grano.dart';
import '../../logic/trabajo_logic.dart';
import 'color_picker_accesible.dart';
import 'grano_picker_accesible.dart';

class DrawerEdicionGrano extends StatefulWidget {
  final TrabajoLogic logic;
  final List<Pigmento> pigmentosDisponibles;
  final List<GranoMarmol> granosDisponibles;

  const DrawerEdicionGrano({
    super.key,
    required this.logic,
    required this.pigmentosDisponibles,
    required this.granosDisponibles,
  });

  @override
  State<DrawerEdicionGrano> createState() => _DrawerEdicionGranoState();
}

class _DrawerEdicionGranoState extends State<DrawerEdicionGrano> {
  GranoMarmol? _granoSeleccionado;
  Pigmento? _pigmentoSeleccionado;
  double _densidad = 0.5;

  void _actualizarPreview() {
    if (_granoSeleccionado != null && _densidad > 0 && 
        !(_pigmentoSeleccionado != null && !_granoSeleccionado!.esTenible)) {
      widget.logic.actualizarCapaEnEdicion(
        CapaGrano.crear(
          grano: _granoSeleccionado!,
          pigmento: _pigmentoSeleccionado,
          densidad: _densidad,
        ),
      );
    } else {
      widget.logic.actualizarCapaEnEdicion(null);
    }
  }

  void _anadirCapa() {
    if (_granoSeleccionado == null) return;

    if (_densidad <= 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La densidad debe ser mayor a 0% para añadir la capa.')),
      );
      return;
    }

    if (_pigmentoSeleccionado != null && !_granoSeleccionado!.esTenible) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('No se puede asignar pigmento a un grano no teñible.')),
      );
      return;
    }

    final capa = CapaGrano.crear(
      grano: _granoSeleccionado!,
      pigmento: _pigmentoSeleccionado,
      densidad: _densidad,
    );

    widget.logic.agregarCapaGrano(capa);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Capa de grano añadida correctamente')),
    );

      setState(() {
        _granoSeleccionado = null;
        _pigmentoSeleccionado = null;
        _densidad = 0.5;
      });
      _actualizarPreview();
    }

  Future<void> _mostrarDialogoColorPersonalizado(BuildContext context) async {
    Color tempColor = Colors.blue;
    final result = await showDialog<Color>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Color del Pigmento'),
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
                  child: const Text('Añadir y Teñir Piedra')),
            ],
          );
        });

    if (result != null) {
      try {
        final hexString =
            '#${result.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
        final nuevoPigmento = Pigmento.personalizado(hexString);
        widget.logic.agregarPigmentoPersonalizado(nuevoPigmento);
        setState(() {
          _pigmentoSeleccionado = nuevoPigmento;
        });
        _actualizarPreview();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error procesando color')));
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: GranoPickerAccesible(
                      granosDisponibles: widget.granosDisponibles,
                      granoSeleccionado: _granoSeleccionado,
                      onGranoSeleccionado: (grano) {
                        setState(() {
                          _granoSeleccionado = grano;
                          if (!grano.esTenible) {
                            _pigmentoSeleccionado = null;
                          }
                        });
                        _actualizarPreview();
                      },
                      etiqueta: 'Tipo de Grano',
                    ),
                  ),
                ),
                if (_granoSeleccionado != null &&
                    _granoSeleccionado!.esTenible) ...[
                  const Divider(height: 16, thickness: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ColorPickerAccesible(
                        pigmentosDisponibles: [
                          ...widget.pigmentosDisponibles,
                          ...widget.logic.pigmentosPersonalizados
                        ],
                        pigmentoSeleccionado: _pigmentoSeleccionado,
                        onPigmentoSeleccionado: (pigmento) {
                          setState(() {
                            _pigmentoSeleccionado = pigmento;
                          });
                          _actualizarPreview();
                        },
                        onAddCustomColor: () =>
                            _mostrarDialogoColorPersonalizado(context),
                        etiqueta: 'Color del Grano',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Densidad',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Semantics(
                slider: true,
                label: 'Ajustar densidad del grano',
                child: Slider(
                  value: _densidad,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(_densidad * 100).round()}%',
                  onChanged: (val) {
                    setState(() {
                      _densidad = val;
                    });
                    _actualizarPreview();
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: _granoSeleccionado != null ? _anadirCapa : null,
                icon: const Icon(Icons.add),
                label: const Text('Añadir Capa'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
