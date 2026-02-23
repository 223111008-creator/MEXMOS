import 'package:flutter/foundation.dart';
import '../domain/models/receta.dart';
import '../domain/models/pigmento.dart';
import '../domain/models/grano_marmol.dart';
import '../domain/models/configuracion_pedido.dart';

/// Maneja el estado en tiempo real de la configuración que el usuario 
/// está armando (receta seleccionada, metros y personalizaciones).
class ConfiguradorLogic extends ChangeNotifier {
  Receta? _recetaSeleccionada;
  double _metrosCuadrados = 1.0;
  
  final Map<String, Pigmento> _pigmentosSeleccionados = {};
  final Map<String, GranoMarmol> _granosSeleccionados = {};

  /// Receta base elegida por el usuario.
  Receta? get recetaSeleccionada => _recetaSeleccionada;
  
  /// Cantidad de metros cuadrados a fabricar.
  double get metrosCuadrados => _metrosCuadrados;
  
  /// Mapa inmutable de pigmentos personalizados.
  Map<String, Pigmento> get pigmentosSeleccionados => Map.unmodifiable(_pigmentosSeleccionados);
  
  /// Mapa inmutable de granos personalizados.
  Map<String, GranoMarmol> get granosSeleccionados => Map.unmodifiable(_granosSeleccionados);

  /// Establece la receta base y limpia cualquier personalización previa.
  void seleccionarReceta(Receta receta) {
    _recetaSeleccionada = receta;
    resetearPersonalizaciones(); // Limpia los mapas, pero llama a notifyListeners allí mismo
  }

  /// Actualiza los metros cuadrados, validando que sean mayores a 0.
  void actualizarMetros(double metros) {
    if (metros > 0) {
      _metrosCuadrados = metros;
      notifyListeners();
    }
  }

  /// Agrega o actualiza un pigmento personalizado en la mezcla.
  void personalizarPigmento(String pigmentoOriginalId, Pigmento nuevoPigmento) {
    _pigmentosSeleccionados[pigmentoOriginalId] = nuevoPigmento;
    notifyListeners();
  }

  /// Agrega o actualiza un grano personalizado en la mezcla.
  void personalizarGrano(String granoOriginalId, GranoMarmol nuevoGrano) {
    _granosSeleccionados[granoOriginalId] = nuevoGrano;
    notifyListeners();
  }

  /// Revierte la configuración a los materiales originales de la receta base.
  void resetearPersonalizaciones() {
    _pigmentosSeleccionados.clear();
    _granosSeleccionados.clear();
    notifyListeners();
  }

  /// Construye el objeto inmutable de configuración listo para enviar a producción.
  ConfiguracionPedido? generarConfiguracion() {
    if (_recetaSeleccionada == null) return null;
    
    return ConfiguracionPedido(
      id: 'conf_${DateTime.now().millisecondsSinceEpoch}',
      recetaBase: _recetaSeleccionada!,
      metrosCuadrados: _metrosCuadrados,
      pigmentosSeleccionados: Map.unmodifiable(_pigmentosSeleccionados),
      granosSeleccionados: Map.unmodifiable(_granosSeleccionados),
      fechaCreacion: DateTime.now(),
    );
  }
}