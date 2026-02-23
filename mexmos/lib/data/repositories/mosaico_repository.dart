import 'package:flutter/material.dart';
import '../models/mosaico_model.dart';
import '../models/pedido_pigmento_model.dart';

/// Base repository for Mosaico, Pigmento, and Pedido data
class MosaicoRepository {
  /// Simulated database of mosaicos
  final List<Mosaico> _mosaicos = [
    Mosaico(
      id: '1',
      nombre: 'Mosaico Clásico',
      descripcion: 'Diseño tradicional con patrones geométricos',
      pathSvg: 'assets/mosaicos/clasico.svg',
      coloresDisponibles: [
        Colors.blue,
        Colors.red,
        Colors.green,
        Colors.yellow,
      ],
    ),
    Mosaico(
      id: '2',
      nombre: 'Mosaico Moderno',
      descripcion: 'Diseño contemporáneo y minimalista',
      pathSvg: 'assets/mosaicos/moderno.svg',
      coloresDisponibles: [
        Colors.black,
        Colors.white,
        Colors.grey,
        Colors.purple,
      ],
    ),
  ];

  final List<Pedido> _pedidos = [];

  /// Get all available mosaicos
  Future<List<Mosaico>> getAllMosaicos() async {
    return Future.delayed(const Duration(milliseconds: 500), () => _mosaicos);
  }

  /// Get mosaico by ID
  Future<Mosaico?> getMosaicoById(String id) async {
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => _mosaicos.firstWhere(
        (m) => m.id == id,
        orElse: () => throw Exception('Mosaico not found'),
      ),
    );
  }

  /// Save a new order
  Future<void> savePedido(Pedido pedido) async {
    pedido.calcularPrecio();
    _pedidos.add(pedido);
    return Future.delayed(const Duration(milliseconds: 500));
  }

  /// Get all orders
  Future<List<Pedido>> getAllPedidos() async {
    return Future.delayed(const Duration(milliseconds: 500), () => _pedidos);
  }
}
