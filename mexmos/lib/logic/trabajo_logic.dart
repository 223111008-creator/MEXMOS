// lib/logic/trabajo_logic.dart
import 'package:flutter/foundation.dart';
import '../domain/models/pigmento.dart';
import '../domain/models/grano_marmol.dart';
import '../domain/models/capa_grano.dart';

enum OpcionDrawer { base, grano, capas, acabado }

class TrabajoLogic extends ChangeNotifier {
  OpcionDrawer _opcionSeleccionada = OpcionDrawer.base;
  OpcionDrawer get opcionSeleccionada => _opcionSeleccionada;

  // --- Propiedades de Base ---
  Pigmento? _colorBaseSeleccionado;
  double _opacidadBase = 1.0;
  
  Pigmento? get colorBaseSeleccionado => _colorBaseSeleccionado;
  double get opacidadBase => _opacidadBase;

  // --- Propiedades de Granos (Capas) ---
  final List<CapaGrano> _capasGrano = [];
  List<CapaGrano> get capasGrano => List.unmodifiable(_capasGrano);

  // --- Propiedades de Acabado ---
  String _acabadoSeleccionado = 'Mate';
  String get acabadoSeleccionado => _acabadoSeleccionado;

  // --- Métodos ---
  void seleccionarOpcion(OpcionDrawer opcion) {
    if (_opcionSeleccionada != opcion) {
      _opcionSeleccionada = opcion;
      notifyListeners();
    }
  }

  void seleccionarColorBase(Pigmento pigmento) {
    _colorBaseSeleccionado = pigmento;
    notifyListeners();
  }

  void actualizarOpacidadBase(double opacidad) {
    _opacidadBase = opacidad.clamp(0.0, 1.0);
    notifyListeners();
  }

  void agregarCapaGrano(CapaGrano capa) {
    _capasGrano.add(capa);
    notifyListeners();
  }

  void eliminarCapaGrano(String idCapa) {
    _capasGrano.removeWhere((c) => c.id == idCapa);
    notifyListeners();
  }

  void actualizarAcabado(String acabado) {
    _acabadoSeleccionado = acabado;
    notifyListeners();
  }
}