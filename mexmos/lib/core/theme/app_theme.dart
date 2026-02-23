import 'package:flutter/material.dart';

/// WCAG-compliant theme configuration
class AppTheme {
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color errorColor = Color(0xFFB00020);
  
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  
  static const double fontSizeXSmall = 12.0;
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 24.0;

  /// Get the ThemeData with WCAG compliance
  static ThemeData getThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        surface: surfaceColor,
      ),
      textTheme: const TextTheme(
        bodySmall: TextStyle(fontSize: fontSizeSmall),
        bodyMedium: TextStyle(fontSize: fontSizeMedium),
        bodyLarge: TextStyle(fontSize: fontSizeLarge),
        displaySmall: TextStyle(fontSize: fontSizeXLarge),
      ),
    );
  }
}
