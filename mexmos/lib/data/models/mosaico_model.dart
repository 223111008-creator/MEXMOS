import 'package:flutter/material.dart';

class Mosaico {
  final String id;
  final String nombre;
  final String descripcion;
  final String pathSvg; // Usaremos SVGs para permitir el cambio de color dinámico
  final List<Color> coloresDisponibles;

  Mosaico({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.pathSvg,
    required this.coloresDisponibles,
  });
}