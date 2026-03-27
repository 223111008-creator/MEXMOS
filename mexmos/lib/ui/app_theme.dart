import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color brandNavy = Color(0xFF0D1B2A);
  static const Color brandCobalt = Color(0xFF1A4B8C);
  static const Color brandCobalt2 = Color(0xFF1E5FAD);
  static const Color brandTerra = Color(0xFFC8741A);
  static const Color brandTerra2 = Color(0xFFA85E12);
  static const Color brandGold = Color(0xFFD4A843);
  static const Color brandStone = Color(0xFFF5F2EC);
  static const Color brandStone2 = Color(0xFFEDE9E0);
  static const Color brandInk = Color(0xFF1A1A2E);

  // Semantic Colors
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surfacePanel = Color(0xFF162233);
  static const Color surfaceCard = Color(0xFF1E2E42);
  static const Color surfaceHover = Color(0xFF243550);
  static const Color surfaceLight = Color(0xFFF5F2EC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFFF0EDE8);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF5B7A99);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textDarkSec = Color(0xFF4A5568);

  static const Color borderSubtle = Color(0x0FFFFFFF); // rgba(255,255,255,0.06) - ~15 alpha out of 255
  static const Color borderPanel = Color(0x1AFFFFFF); // rgba(255,255,255,0.10) - ~26 alpha out of 255
  static const Color borderAccent = Color(0x66C8741A); // rgba(200,116,26,0.4)

  static const Color focusRing = Color(0xFF1A6BBF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surfaceDark,
      colorScheme: const ColorScheme.dark(
        primary: brandTerra,
        secondary: brandCobalt,
        surface: surfacePanel,
        background: surfaceDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.syne(color: textPrimary, fontWeight: FontWeight.w800),
        displayMedium: GoogleFonts.syne(color: textPrimary, fontWeight: FontWeight.w700),
        displaySmall: GoogleFonts.syne(color: textPrimary, fontWeight: FontWeight.w600),
        headlineLarge: GoogleFonts.syne(color: textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.syne(color: textPrimary, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.syne(color: textPrimary, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.syne(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.dmSans(color: textPrimary, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.dmSans(color: textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.dmSans(color: textPrimary),
        bodyMedium: GoogleFonts.dmSans(color: textPrimary),
        bodySmall: GoogleFonts.dmSans(color: textSecondary),
        labelLarge: GoogleFonts.dmSans(color: textPrimary, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.dmSans(color: textPrimary, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.dmSans(color: textMuted),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfacePanel,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      dividerTheme: const DividerThemeData(
        color: borderPanel,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: textSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandTerra,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.syne(fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        ),
      ),
      // cardTheme: CardTheme(
      //   color: surfaceCard,
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     side: const BorderSide(color: borderSubtle),
      //   ),
      // ),
    );
  }

  static ThemeData get highContrastDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFFFF00),
        secondary: Color(0xFF00FFFF),
        surface: Colors.black,
        background: Colors.black,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.w800),
        displayMedium: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.w700),
        displaySmall: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.w600),
        headlineLarge: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold),
        bodyMedium: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold),
        bodySmall: GoogleFonts.dmSans(color: Colors.white),
        labelLarge: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w700),
        labelMedium: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w700),
        labelSmall: GoogleFonts.dmSans(color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.white,
        thickness: 2,
        space: 2,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFF00),
          foregroundColor: Colors.black,
          textStyle: GoogleFonts.syne(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        ),
      ),
    );
  }
}
