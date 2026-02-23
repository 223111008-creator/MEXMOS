import 'package:flutter/material.dart';

/// Define el sistema de diseño global de la aplicación.
class AppTheme {
  /// Retorna el tema claro predeterminado basado en Material 3.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF1E88E5), // Azul industrial
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}