class PastaBase {
  final String id;
  final String nombre;
  final String cementoInsumoId;
  final String marmolinaInsumoId;
  final double proporcionCemento;
  final double proporcionMarmolina;
  final double aguaLitrosPorKgSeco;

  const PastaBase({
    required this.id,
    required this.nombre,
    required this.cementoInsumoId,
    required this.marmolinaInsumoId,
    required this.proporcionCemento,
    required this.proporcionMarmolina,
    required this.aguaLitrosPorKgSeco,
  })  : assert(id.length > 0, 'El ID no puede estar vacío.'),
        assert(nombre.length > 0, 'El nombre no puede estar vacío.'),
        assert(proporcionCemento > 0, 'La proporción de cemento debe ser mayor a 0.'),
        assert(proporcionMarmolina > 0, 'La proporción de marmolina debe ser mayor a 0.'),
        assert(aguaLitrosPorKgSeco > 0, 'Debe incluir una proporción válida de agua.');

  PastaBase copyWith({
    String? id,
    String? nombre,
    String? cementoInsumoId,
    String? marmolinaInsumoId,
    double? proporcionCemento,
    double? proporcionMarmolina,
    double? aguaLitrosPorKgSeco,
  }) {
    return PastaBase(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cementoInsumoId: cementoInsumoId ?? this.cementoInsumoId,
      marmolinaInsumoId: marmolinaInsumoId ?? this.marmolinaInsumoId,
      proporcionCemento: proporcionCemento ?? this.proporcionCemento,
      proporcionMarmolina: proporcionMarmolina ?? this.proporcionMarmolina,
      aguaLitrosPorKgSeco: aguaLitrosPorKgSeco ?? this.aguaLitrosPorKgSeco,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'cementoInsumoId': cementoInsumoId,
        'marmolinaInsumoId': marmolinaInsumoId,
        'proporcionCemento': proporcionCemento,
        'proporcionMarmolina': proporcionMarmolina,
        'aguaLitrosPorKgSeco': aguaLitrosPorKgSeco,
      };

  factory PastaBase.fromJson(Map<String, dynamic> json) {
    return PastaBase(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      cementoInsumoId: json['cementoInsumoId'] as String,
      marmolinaInsumoId: json['marmolinaInsumoId'] as String,
      proporcionCemento: (json['proporcionCemento'] as num).toDouble(),
      proporcionMarmolina: (json['proporcionMarmolina'] as num).toDouble(),
      aguaLitrosPorKgSeco: (json['aguaLitrosPorKgSeco'] as num).toDouble(),
    );
  }
}