import 'package:flutter/foundation.dart';
import '../domain/models/configuracion_pedido.dart';

/// Maneja el estado de los pedidos acumulados (carrito de compras) 
/// antes de ser confirmados para producción.
class CarritoLogic extends ChangeNotifier {
  final List<ConfiguracionPedido> _pedidos = [];

  /// Retorna una lista inmutable de los pedidos actuales.
  List<ConfiguracionPedido> get pedidos => List.unmodifiable(_pedidos);

  /// Añade una nueva configuración terminada al carrito.
  void agregarPedido(ConfiguracionPedido pedido) {
    _pedidos.add(pedido);
    notifyListeners();
  }

  /// Vacía por completo el carrito de compras.
  void limpiarCarrito() {
    _pedidos.clear();
    notifyListeners();
  }
}