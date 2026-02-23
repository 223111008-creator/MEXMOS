import 'insumo.dart';

/// Representa una fila específica en la Lista de Materiales (BOM) o Ficha Técnica.
/// Asocia un insumo físico con la cantidad absoluta requerida para la producción.
class LineaInsumo {
  /// El insumo base requerido.
  final Insumo insumo;

  /// Cantidad total necesaria en la unidad de medida del insumo (generalmente kilogramos).
  final double cantidadTotalKg;

  /// Constructor constante con validación estricta de cantidad.
  const LineaInsumo({
    required this.insumo,
    required this.cantidadTotalKg,
  }) : assert(cantidadTotalKg > 0, 'La cantidad total debe ser estrictamente mayor a 0.');

  /// Crea una copia inmutable del objeto con propiedades actualizadas.
  LineaInsumo copyWith({
    Insumo? insumo,
    double? cantidadTotalKg,
  }) {
    return LineaInsumo(
      insumo: insumo ?? this.insumo,
      cantidadTotalKg: cantidadTotalKg ?? this.cantidadTotalKg,
    );
  }

  /// Serializa el objeto a formato JSON.
  Map<String, dynamic> toJson() => {
        'insumo': insumo.toJson(),
        'cantidadTotalKg': cantidadTotalKg,
      };

  /// Deserializa el objeto desde formato JSON.
  factory LineaInsumo.fromJson(Map<String, dynamic> json) {
    return LineaInsumo(
      insumo: Insumo.fromJson(json['insumo'] as Map<String, dynamic>),
      cantidadTotalKg: (json['cantidadTotalKg'] as num).toDouble(),
    );
  }
}