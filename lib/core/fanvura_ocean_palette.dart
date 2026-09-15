import 'package:flutter/material.dart';

class FanvuraOceanPalette {
  static const Color abyssNavy = Color(0xFF07111E);
  static const Color deepTrench = Color(0xFF0D1F35);
  static const Color marineSurface = Color(0xFF142B47);
  static const Color reefBorder = Color(0xFF1E3E66);
  
  static const Color seafoamGreen = Color(0xFF2DD4BF);
  static const Color cyanWave = Color(0xFF38BDF8);
  static const Color foamWhite = Color(0xFFF0FDF4);
  static const Color saltMuted = Color(0xFF94A3B8);
  static const Color coralAlert = Color(0xFFFB7185);
  static const Color amberWarning = Color(0xFFFBBF24);

  static ThemeData get oceanTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'AppFont',
      scaffoldBackgroundColor: abyssNavy,
      colorScheme: const ColorScheme.dark(
        primary: seafoamGreen,
        secondary: cyanWave,
        surface: marineSurface,
        error: coralAlert,
        onPrimary: abyssNavy,
        onSurface: foamWhite,
      ),
      cardTheme: CardThemeData(
        color: deepTrench,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: reefBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: abyssNavy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'AppFont',
          color: foamWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: deepTrench,
        selectedItemColor: seafoamGreen,
        unselectedItemColor: saltMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seafoamGreen,
          foregroundColor: abyssNavy,
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: 'AppFont',
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: marineSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: reefBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: reefBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: seafoamGreen, width: 1.5),
        ),
        labelStyle: const TextStyle(color: saltMuted),
        hintStyle: const TextStyle(color: saltMuted),
      ),
    );
  }
}
