import 'package:flutter/material.dart';

class TransformadorColor {
  static Color aplicarFiltro(Color original, String modo) {
    if (modo == 'Normal') {
      return original;
    }

    // Usamos las nuevas propiedades r, g, b que retornan valores de 0.0 a 1.0
    final double luminosidad = (original.r + original.g + original.b) / 3.0;
    
    // Multiplicamos por 255 y redondeamos para crear el nuevo color en RGB
    return Color.fromARGB(
      (original.a * 255.0).round().clamp(0, 255),
      (luminosidad * 255.0).round().clamp(0, 255),
      (luminosidad * 255.0).round().clamp(0, 255),
      (luminosidad * 255.0).round().clamp(0, 255),
    );
  }

  static Color hexToColor(String hexCode) {
    final hexStr = hexCode.replaceFirst('#', '0xFF');
    return Color(int.parse(hexStr));
  }
}