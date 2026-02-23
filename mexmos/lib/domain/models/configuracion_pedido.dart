import 'receta.dart';
import 'pigmento.dart';
import 'grano_marmol.dart';

class ConfiguracionPedido {
  final String id;
  final Receta recetaBase;
  final Map<String, Pigmento> _pigmentosSeleccionados;
  final Map<String, GranoMarmol> _granosSeleccionados;
  final double metrosCuadrados;
  final DateTime fechaCreacion;

  const ConfiguracionPedido({
    required this.id,
    required this.recetaBase,
    Map<String, Pigmento> pigmentosSeleccionados = const {},
    Map<String, GranoMarmol> granosSeleccionados = const {},
    required this.metrosCuadrados,
    required this.fechaCreacion,
  })  : _pigmentosSeleccionados = pigmentosSeleccionados,
        _granosSeleccionados = granosSeleccionados,
        assert(id.length > 0, 'El ID no puede estar vacío.'),
        assert(metrosCuadrados > 0, 'Los metros cuadrados deben ser mayores a 0.');

  Map<String, Pigmento> get pigmentosSeleccionados => Map.unmodifiable(_pigmentosSeleccionados);
  Map<String, GranoMarmol> get granosSeleccionados => Map.unmodifiable(_granosSeleccionados);

  ConfiguracionPedido copyWith({
    String? id,
    Receta? recetaBase,
    Map<String, Pigmento>? pigmentosSeleccionados,
    Map<String, GranoMarmol>? granosSeleccionados,
    double? metrosCuadrados,
    DateTime? fechaCreacion,
  }) {
    return ConfiguracionPedido(
      id: id ?? this.id,
      recetaBase: recetaBase ?? this.recetaBase,
      pigmentosSeleccionados: pigmentosSeleccionados ?? _pigmentosSeleccionados,
      granosSeleccionados: granosSeleccionados ?? _granosSeleccionados,
      metrosCuadrados: metrosCuadrados ?? this.metrosCuadrados,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'recetaBase': recetaBase.toJson(),
        'pigmentosSeleccionados': _pigmentosSeleccionados.map((k, v) => MapEntry(k, v.toJson())),
        'granosSeleccionados': _granosSeleccionados.map((k, v) => MapEntry(k, v.toJson())),
        'metrosCuadrados': metrosCuadrados,
        'fechaCreacion': fechaCreacion.toIso8601String(),
      };

  factory ConfiguracionPedido.fromJson(Map<String, dynamic> json) {
    return ConfiguracionPedido(
      id: json['id'] as String,
      recetaBase: Receta.fromJson(json['recetaBase'] as Map<String, dynamic>),
      pigmentosSeleccionados: (json['pigmentosSeleccionados'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, Pigmento.fromJson(v as Map<String, dynamic>)),
      ),
      granosSeleccionados: (json['granosSeleccionados'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, GranoMarmol.fromJson(v as Map<String, dynamic>)),
      ),
      metrosCuadrados: (json['metrosCuadrados'] as num).toDouble(),
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    );
  }
}