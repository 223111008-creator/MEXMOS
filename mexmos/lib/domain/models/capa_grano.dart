import 'grano_marmol.dart';
import 'pigmento.dart';

class CapaGrano {
  final String id;
  final GranoMarmol grano;
  final Pigmento? pigmento;
  final double densidad;

  CapaGrano({
    required this.id,
    required this.grano,
    this.pigmento,
    this.densidad = 0.5,
  }) {
    // Validación de negocio
    if (pigmento != null && !grano.esTenible) {
      throw ArgumentError(
          'No se puede asignar pigmento a un grano no teñible.');
    }
    if (densidad < 0.0 || densidad > 1.0) {
      throw ArgumentError('La densidad debe estar entre 0.0 y 1.0');
    }
  }

  factory CapaGrano.crear({
    required GranoMarmol grano,
    Pigmento? pigmento,
    double densidad = 0.5,
  }) {
    return CapaGrano(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      grano: grano,
      pigmento: pigmento,
      densidad: densidad,
    );
  }

  CapaGrano copyWith({
    String? id,
    GranoMarmol? grano,
    Pigmento? pigmento,
    double? densidad,
  }) {
    return CapaGrano(
      id: id ?? this.id,
      grano: grano ?? this.grano,
      pigmento: pigmento ?? this.pigmento,
      densidad: densidad ?? this.densidad,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'grano': grano.toJson(),
        'pigmento': pigmento?.toJson(),
        'densidad': densidad,
      };

  factory CapaGrano.fromJson(Map<String, dynamic> json) {
    return CapaGrano(
      id: json['id'] as String,
      grano: GranoMarmol.fromJson(json['grano'] as Map<String, dynamic>),
      pigmento: json['pigmento'] != null
          ? Pigmento.fromJson(json['pigmento'] as Map<String, dynamic>)
          : null,
      densidad: json['densidad'] as double,
    );
  }
}
