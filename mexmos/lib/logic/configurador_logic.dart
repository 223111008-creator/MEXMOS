import 'package:flutter/material.dart';

/// Controla el cambio de colores en tiempo real en el configurador
class ConfiguradorLogic extends ChangeNotifier {
  /// Map de mosaicoId -> IDs de colores seleccionados
  final Map<String, String> _coloresSeleccionados = {};

  /// Obtener color seleccionado para un mosaico específico
  String? getColorSeleccionado(String mosaicoId) {
    return _coloresSeleccionados[mosaicoId];
  }

  /// Establecer color seleccionado para un mosaico específico
  void setColorSeleccionado(String mosaicoId, String colorId) {
    _coloresSeleccionados[mosaicoId] = colorId;
    notifyListeners();
  }

  /// Resetear todas las selecciones
  void resetearSelecciones() {
    _coloresSeleccionados.clear();
    notifyListeners();
  }

  /// Obtener todas las selecciones
  Map<String, String> obtenerSelecciones() {
    return Map.unmodifiable(_coloresSeleccionados);
  }

  /// Verificar si un mosaico ha sido configurado
  bool estaConfigurado(String mosaicoId) {
    return _coloresSeleccionados.containsKey(mosaicoId);
  }

  /// Obtener cantidad de mosaicos configurados
  int obtenerCantidadConfigurados() {
    return _coloresSeleccionados.length;
  }
}
