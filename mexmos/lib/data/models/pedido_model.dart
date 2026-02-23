/// Pedido representa la ficha técnica final del cliente
class Pedido {
  final String id;
  final Map<String, String> configuracion; // {mosaicoId: colorId}
  final double metrosCuadrados;
  final DateTime fechaCreacion;
  final String? clienteNombre;
  final String? clienteEmail;
  double precioTotal;

  Pedido({
    required this.id,
    required this.configuracion,
    required this.metrosCuadrados,
    required this.fechaCreacion,
    this.clienteNombre,
    this.clienteEmail,
    this.precioTotal = 0.0,
  });

  /// Calcular el precio total del pedido basado en metros cuadrados
  void calcularPrecio({double precioMetroCuadrado = 50.0}) {
    precioTotal = metrosCuadrados * precioMetroCuadrado;
  }

  /// Obtener resumen del pedido
  String obtenerResumen() {
    return 'Pedido #$id - ${metrosCuadrados}m² - \$${precioTotal.toStringAsFixed(2)}';
  }
}
