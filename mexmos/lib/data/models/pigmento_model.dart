import 'package:flutter/material.dart';

/// Pigmento define los colores físicos disponibles (Ej: Rojo Óxido, Azul Cobalto)
class Pigmento {
  final String id;
  final String nombre;
  final Color color;
  final String codigoFisico; // Código del pigmento físico para producción

  Pigmento({
    required this.id,
    required this.nombre,
    required this.color,
    required this.codigoFisico,
  });
}
