import 'package:flutter/material.dart';

/// Maneja los metros cuadrados y el pedido final
class CarritoLogic extends ChangeNotifier {
  /// Metros cuadrados solicitados
  double _metrosCuadrados = 0.0;
  
  /// Configuración del pedido: {mosaicoId: colorId}
  final Map<String, String> _configuracion = {};

  /// Obtener metros cuadrados
  double get metrosCuadrados => _metrosCuadrados;

  /// Establecer metros cuadrados
  void setMetrosCuadrados(double metros) {
    if (metros > 0) {
      _metrosCuadrados = metros;
      notifyListeners();
    }
  }

  /// Agregar configuración de mosaico
  void agregarAlCarrito(String mosaicoId, String colorId) {
    _configuracion[mosaicoId] = colorId;
    notifyListeners();
  }

  /// Remover mosaico del carrito
  void removerDelCarrito(String mosaicoId) {
    _configuracion.remove(mosaicoId);
    notifyListeners();
  }

  /// Obtener configuración del carrito
  Map<String, String> obtenerConfiguracion() {
    return Map.unmodifiable(_configuracion);
  }

  /// Calcular precio total
  double calcularTotal({double precioMetroCuadrado = 50.0}) {
    return _metrosCuadrados * precioMetroCuadrado;
  }

  /// Limpiar carrito
  void limpiarCarrito() {
    _metrosCuadrados = 0.0;
    _configuracion.clear();
    notifyListeners();
  }

  /// Verificar si el carrito está listo para confirmación
  bool estaListo() {
    return _metrosCuadrados > 0 && _configuracion.isNotEmpty;
  }

  /// Obtener cantidad de items configurados
  int obtenerCantidadItems() {
    return _configuracion.length;
  }
}
