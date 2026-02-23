import 'pigmento.dart';

class PigmentoEnReceta {
  final Pigmento pigmento;
  final double cantidadKgPorM2;

  const PigmentoEnReceta({
    required this.pigmento,
    required this.cantidadKgPorM2,
  }) : assert(cantidadKgPorM2 > 0, 'La cantidad de pigmento debe ser mayor a 0.');

  PigmentoEnReceta copyWith({
    Pigmento? pigmento,
    double? cantidadKgPorM2,
  }) {
    return PigmentoEnReceta(
      pigmento: pigmento ?? this.pigmento,
      cantidadKgPorM2: cantidadKgPorM2 ?? this.cantidadKgPorM2,
    );
  }

  Map<String, dynamic> toJson() => {
        'pigmento': pigmento.toJson(),
        'cantidadKgPorM2': cantidadKgPorM2,
      };

  factory PigmentoEnReceta.fromJson(Map<String, dynamic> json) {
    return PigmentoEnReceta(
      pigmento: Pigmento.fromJson(json['pigmento'] as Map<String, dynamic>),
      cantidadKgPorM2: (json['cantidadKgPorM2'] as num).toDouble(),
    );
  }
}