// lib/ui/widgets/drawer_edicion_grano.dart
import 'package:flutter/material.dart';
import '../../domain/models/pigmento.dart';
import '../../domain/models/grano_marmol.dart';
import '../../domain/models/capa_grano.dart';
import '../../logic/trabajo_logic.dart';

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

  void _agregarCapa() {
    if (_granoSeleccionado == null) return;

    final nuevaCapa = CapaGrano(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      grano: _granoSeleccionado!,
      pigmento: _granoSeleccionado!.esTenible ? _pigmentoSeleccionado : null,
      densidad: _densidad,
    );

    widget.logic.agregarCapaGrano(nuevaCapa);

    // Resetear estado local para la siguiente capa
    setState(() {
      _granoSeleccionado = null;
      _pigmentoSeleccionado = null;
      _densidad = 0.5;
    });
    
    // Opcional: Navegar a la vista de capas automáticamente
    // widget.logic.seleccionarOpcion(OpcionDrawer.capas);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna izquierda: Selección
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tipo de Grano', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<GranoMarmol>(
                  isExpanded: true,
                  value: _granoSeleccionado,
                  hint: const Text('Selecciona un grano'),
                  items: widget.granosDisponibles.map((g) {
                    return DropdownMenuItem(value: g, child: Text(g.nombre));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _granoSeleccionado = val;
                      if (val != null && !val.esTenible) {
                        _pigmentoSeleccionado = null; // Limpiar si no es teñible
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),
                if (_granoSeleccionado?.esTenible == true) ...[
                  const Text('Color del Grano', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<Pigmento>(
                    isExpanded: true,
                    value: _pigmentoSeleccionado,
                    hint: const Text('Color natural (sin teñir)'),
                    items: widget.pigmentosDisponibles.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p.nombre));
                    }).toList(),
                    onChanged: (val) => setState(() => _pigmentoSeleccionado = val),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Columna derecha: Densidad y Botón
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Densidad', style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: _densidad,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  label: '${(_densidad * 100).round()}%',
                  onChanged: (val) => setState(() => _densidad = val),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _granoSeleccionado == null ? null : _agregarCapa,
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir a la mezcla'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}