import 'package:flutter/material.dart';

class MarineTheme {
  static const Color deepAbyss = Color(0xFF0A192F);
  static const Color reefTeal = Color(0xFF00B4D8);
  static const Color seafoam = Color(0xFF90E0EF);
  static const Color coralOrange = Color(0xFFFF6B6B);
  static const Color surfaceCard = Color(0xFF132A4A);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'AppFont',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepAbyss,
      colorScheme: const ColorScheme.dark(
        primary: reefTeal,
        secondary: coralOrange,
        surface: surfaceCard,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: deepAbyss,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
