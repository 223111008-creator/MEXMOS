import 'enums.dart';

class Insumo {
  final String id;
  final String nombre;
  final TipoInsumo tipo;
  final double costoPorKg;
  final String? codigoProveedor;
  final String unidadMedida;

  const Insumo({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.costoPorKg,
    this.codigoProveedor,
    this.unidadMedida = 'kg',
  })  : assert(id.length > 0, 'El ID del insumo no puede estar vacío.'),
        assert(nombre.length > 0, 'El nombre del insumo no puede estar vacío.'),
        assert(costoPorKg >= 0, 'El costo no puede ser negativo.');

  Insumo copyWith({
    String? id,
    String? nombre,
    TipoInsumo? tipo,
    double? costoPorKg,
    String? codigoProveedor,
    String? unidadMedida,
  }) {
    return Insumo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      costoPorKg: costoPorKg ?? this.costoPorKg,
      codigoProveedor: codigoProveedor ?? this.codigoProveedor,
      unidadMedida: unidadMedida ?? this.unidadMedida,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'tipo': tipo.name,
        'costoPorKg': costoPorKg,
        'codigoProveedor': codigoProveedor,
        'unidadMedida': unidadMedida,
      };

  factory Insumo.fromJson(Map<String, dynamic> json) {
    return Insumo(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      tipo: TipoInsumo.values.firstWhere((e) => e.name == json['tipo']),
      costoPorKg: (json['costoPorKg'] as num).toDouble(),
      codigoProveedor: json['codigoProveedor'] as String?,
      unidadMedida: json['unidadMedida'] as String? ?? 'kg',
    );
  }
}