import 'configuracion_pedido.dart';
import 'linea_insumo.dart';

class FichaTecnica {
  final String id;
  final String pedidoId;
  final ConfiguracionPedido configuracion;
  final List<LineaInsumo> _insumosRequeridos;
  final String instruccionesMezcla;
  final DateTime fechaGeneracion;
  final double totalKg;

  const FichaTecnica({
    required this.id,
    required this.pedidoId,
    required this.configuracion,
    required List<LineaInsumo> insumosRequeridos,
    required this.instruccionesMezcla,
    required this.fechaGeneracion,
    required this.totalKg,
  })  : _insumosRequeridos = insumosRequeridos,
        assert(id.length > 0, 'El ID de la ficha no puede estar vacío.'),
        assert(pedidoId.length > 0, 'El ID del pedido no puede estar vacío.'),
        assert(insumosRequeridos.length > 0, 'Debe haber al menos un insumo en la ficha.'),
        assert(totalKg > 0, 'El total en kg debe ser mayor a 0.');

  List<LineaInsumo> get insumosRequeridos => List.unmodifiable(_insumosRequeridos);

  FichaTecnica copyWith({
    String? id,
    String? pedidoId,
    ConfiguracionPedido? configuracion,
    List<LineaInsumo>? insumosRequeridos,
    String? instruccionesMezcla,
    DateTime? fechaGeneracion,
    double? totalKg,
  }) {
    return FichaTecnica(
      id: id ?? this.id,
      pedidoId: pedidoId ?? this.pedidoId,
      configuracion: configuracion ?? this.configuracion,
      insumosRequeridos: insumosRequeridos ?? _insumosRequeridos,
      instruccionesMezcla: instruccionesMezcla ?? this.instruccionesMezcla,
      fechaGeneracion: fechaGeneracion ?? this.fechaGeneracion,
      totalKg: totalKg ?? this.totalKg,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pedidoId': pedidoId,
        'configuracion': configuracion.toJson(),
        'insumosRequeridos': _insumosRequeridos.map((i) => i.toJson()).toList(),
        'instruccionesMezcla': instruccionesMezcla,
        'fechaGeneracion': fechaGeneracion.toIso8601String(),
        'totalKg': totalKg,
      };

  factory FichaTecnica.fromJson(Map<String, dynamic> json) {
    return FichaTecnica(
      id: json['id'] as String,
      pedidoId: json['pedidoId'] as String,
      configuracion: ConfiguracionPedido.fromJson(json['configuracion'] as Map<String, dynamic>),
      insumosRequeridos: (json['insumosRequeridos'] as List<dynamic>)
          .map((e) => LineaInsumo.fromJson(e as Map<String, dynamic>))
          .toList(),
      instruccionesMezcla: json['instruccionesMezcla'] as String,
      fechaGeneracion: DateTime.parse(json['fechaGeneracion'] as String),
      totalKg: (json['totalKg'] as num).toDouble(),
    );
  }
}