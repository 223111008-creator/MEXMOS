import 'enums.dart';

class GranoMarmol {
  final String id;
  final String nombre;
  final EquipoMolienda equipo;
  final String codigoTamano;
  final String abertura;
  final int colorNatural;
  final bool esTenible;
  final String insumoRelacionadoId;

  const GranoMarmol({
    required this.id,
    required this.nombre,
    required this.equipo,
    required this.codigoTamano,
    required this.abertura,
    required this.colorNatural,
    required this.esTenible,
    required this.insumoRelacionadoId,
  })  : assert(id.length > 0, 'El ID no puede estar vacío.'),
        assert(nombre.length > 0, 'El nombre no puede estar vacío.'),
        assert(insumoRelacionadoId.length > 0, 'Debe estar vinculado a un insumo.');

  GranoMarmol copyWith({
    String? id,
    String? nombre,
    EquipoMolienda? equipo,
    String? codigoTamano,
    String? abertura,
    int? colorNatural,
    bool? esTenible,
    String? insumoRelacionadoId,
  }) {
    return GranoMarmol(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      equipo: equipo ?? this.equipo,
      codigoTamano: codigoTamano ?? this.codigoTamano,
      abertura: abertura ?? this.abertura,
      colorNatural: colorNatural ?? this.colorNatural,
      esTenible: esTenible ?? this.esTenible,
      insumoRelacionadoId: insumoRelacionadoId ?? this.insumoRelacionadoId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'equipo': equipo.name,
        'codigoTamano': codigoTamano,
        'abertura': abertura,
        'colorNatural': colorNatural,
        'esTenible': esTenible,
        'insumoRelacionadoId': insumoRelacionadoId,
      };

  factory GranoMarmol.fromJson(Map<String, dynamic> json) {
    return GranoMarmol(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      equipo: EquipoMolienda.values.firstWhere((e) => e.name == json['equipo']),
      codigoTamano: json['codigoTamano'] as String,
      abertura: json['abertura'] as String,
      colorNatural: json['colorNatural'] as int,
      esTenible: json['esTenible'] as bool,
      insumoRelacionadoId: json['insumoRelacionadoId'] as String,
    );
  }
}