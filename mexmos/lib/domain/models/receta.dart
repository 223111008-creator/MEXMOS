import 'pasta_base.dart';
import 'pigmento_en_receta.dart';
import 'grano_en_receta.dart';

class Receta {
  final String id;
  final String nombre;
  final String? descripcion;
  final PastaBase pastaBase;
  final List<PigmentoEnReceta> _pigmentos;
  final List<GranoEnReceta> _granos;
  final double rendimientoKgPorM2;
  final double aguaLitrosPorM2;
  final DateTime fechaCreacion;
  final bool activa;

  const Receta({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.pastaBase,
    required List<PigmentoEnReceta> pigmentos,
    required List<GranoEnReceta> granos,
    required this.rendimientoKgPorM2,
    required this.aguaLitrosPorM2,
    required this.fechaCreacion,
    this.activa = true,
  })  : _pigmentos = pigmentos,
        _granos = granos,
        assert(id.length > 0, 'El ID no puede estar vacío.'),
        assert(nombre.length > 0, 'El nombre no puede estar vacío.'),
        assert(pigmentos.length > 0, 'Debe incluir al menos un pigmento.'),
        assert(rendimientoKgPorM2 > 0, 'El rendimiento debe ser mayor a 0.'),
        assert(aguaLitrosPorM2 >= 0, 'El agua no puede ser negativa.');

  List<PigmentoEnReceta> get pigmentos => List.unmodifiable(_pigmentos);
  List<GranoEnReceta> get granos => List.unmodifiable(_granos);

  Receta copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    PastaBase? pastaBase,
    List<PigmentoEnReceta>? pigmentos,
    List<GranoEnReceta>? granos,
    double? rendimientoKgPorM2,
    double? aguaLitrosPorM2,
    DateTime? fechaCreacion,
    bool? activa,
  }) {
    return Receta(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      pastaBase: pastaBase ?? this.pastaBase,
      pigmentos: pigmentos ?? _pigmentos,
      granos: granos ?? _granos,
      rendimientoKgPorM2: rendimientoKgPorM2 ?? this.rendimientoKgPorM2,
      aguaLitrosPorM2: aguaLitrosPorM2 ?? this.aguaLitrosPorM2,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activa: activa ?? this.activa,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'pastaBase': pastaBase.toJson(),
        'pigmentos': _pigmentos.map((p) => p.toJson()).toList(),
        'granos': _granos.map((g) => g.toJson()).toList(),
        'rendimientoKgPorM2': rendimientoKgPorM2,
        'aguaLitrosPorM2': aguaLitrosPorM2,
        'fechaCreacion': fechaCreacion.toIso8601String(),
        'activa': activa,
      };

  factory Receta.fromJson(Map<String, dynamic> json) {
    return Receta(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      pastaBase: PastaBase.fromJson(json['pastaBase'] as Map<String, dynamic>),
      pigmentos: (json['pigmentos'] as List<dynamic>)
          .map((e) => PigmentoEnReceta.fromJson(e as Map<String, dynamic>))
          .toList(),
      granos: (json['granos'] as List<dynamic>)
          .map((e) => GranoEnReceta.fromJson(e as Map<String, dynamic>))
          .toList(),
      rendimientoKgPorM2: (json['rendimientoKgPorM2'] as num).toDouble(),
      aguaLitrosPorM2: (json['aguaLitrosPorM2'] as num).toDouble(),
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
      activa: json['activa'] as bool? ?? true,
    );
  }
}