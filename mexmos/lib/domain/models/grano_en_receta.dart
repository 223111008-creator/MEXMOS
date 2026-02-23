import 'grano_marmol.dart';

class GranoEnReceta {
  final GranoMarmol grano;
  final double cantidadKgPorM2;

  const GranoEnReceta({
    required this.grano,
    required this.cantidadKgPorM2,
  }) : assert(cantidadKgPorM2 > 0, 'La cantidad de grano debe ser mayor a 0.');

  GranoEnReceta copyWith({
    GranoMarmol? grano,
    double? cantidadKgPorM2,
  }) {
    return GranoEnReceta(
      grano: grano ?? this.grano,
      cantidadKgPorM2: cantidadKgPorM2 ?? this.cantidadKgPorM2,
    );
  }

  Map<String, dynamic> toJson() => {
        'grano': grano.toJson(),
        'cantidadKgPorM2': cantidadKgPorM2,
      };

  factory GranoEnReceta.fromJson(Map<String, dynamic> json) {
    return GranoEnReceta(
      grano: GranoMarmol.fromJson(json['grano'] as Map<String, dynamic>),
      cantidadKgPorM2: (json['cantidadKgPorM2'] as num).toDouble(),
    );
  }
}