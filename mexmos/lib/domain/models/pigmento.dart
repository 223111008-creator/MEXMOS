class Pigmento {
  final String id;
  final String nombreComercial;
  final String codigoHex;
  final String codigoFisico;
  final String insumoRelacionadoId;

  // Nota: No es 'const' porque RegExp no puede evaluarse en un constructor constante.
  Pigmento({
    required this.id,
    required this.nombreComercial,
    required this.codigoHex,
    required this.codigoFisico,
    required this.insumoRelacionadoId,
  })  : assert(id.isNotEmpty, 'El ID no puede estar vacío.'),
        assert(
          RegExp(r'^#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$')
              .hasMatch(codigoHex),
          'El código hex debe ser válido (ej. #RGB, #RRGGBB, #RRGGBBAA).',
        ),
        assert(insumoRelacionadoId.isNotEmpty,
            'Debe estar vinculado a un insumo.');

  factory Pigmento.personalizado(String hexCode) {
    // Asegurarse de que el hex inicie con #
    final hexFormatted = hexCode.startsWith('#') ? hexCode : '#$hexCode';
    return Pigmento(
      id: 'pig-custom-${DateTime.now().millisecondsSinceEpoch}',
      nombreComercial: 'Personalizado ($hexFormatted)',
      codigoHex: hexFormatted,
      codigoFisico: 'N/A',
      insumoRelacionadoId: 'ins-pig-custom', // Insumo comodín
    );
  }

  Pigmento copyWith({
    String? id,
    String? nombreComercial,
    String? codigoHex,
    String? codigoFisico,
    String? insumoRelacionadoId,
  }) {
    return Pigmento(
      id: id ?? this.id,
      nombreComercial: nombreComercial ?? this.nombreComercial,
      codigoHex: codigoHex ?? this.codigoHex,
      codigoFisico: codigoFisico ?? this.codigoFisico,
      insumoRelacionadoId: insumoRelacionadoId ?? this.insumoRelacionadoId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombreComercial': nombreComercial,
        'codigoHex': codigoHex,
        'codigoFisico': codigoFisico,
        'insumoRelacionadoId': insumoRelacionadoId,
      };

  factory Pigmento.fromJson(Map<String, dynamic> json) {
    return Pigmento(
      id: json['id'] as String,
      nombreComercial: json['nombreComercial'] as String,
      codigoHex: json['codigoHex'] as String,
      codigoFisico: json['codigoFisico'] as String,
      insumoRelacionadoId: json['insumoRelacionadoId'] as String,
    );
  }
}
