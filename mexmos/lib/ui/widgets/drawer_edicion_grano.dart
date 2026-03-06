import 'package:flutter/material.dart';
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

  void _anadirCapa() {
    if (_granoSeleccionado == null) return;

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

    // Reset fields after adding
    setState(() {
      _granoSeleccionado = null;
      _pigmentoSeleccionado = null;
      _densidad = 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
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
                      },
                      etiqueta: 'Tipo de Grano',
                    ),
                  ),
                ),
                if (_granoSeleccionado != null &&
                    _granoSeleccionado!.esTenible) ...[
                  const VerticalDivider(width: 32, thickness: 1),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: ColorPickerAccesible(
                        pigmentosDisponibles: widget.pigmentosDisponibles,
                        pigmentoSeleccionado: _pigmentoSeleccionado,
                        onPigmentoSeleccionado: (pigmento) {
                          setState(() {
                            _pigmentoSeleccionado = pigmento;
                          });
                        },
                        etiqueta: 'Color del Grano',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Densidad',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Semantics(
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
                    },
                  ),
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
