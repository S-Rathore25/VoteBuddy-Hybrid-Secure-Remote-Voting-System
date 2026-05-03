import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1E3A8A),
    primary: const Color(0xFF1E3A8A),
    secondary: const Color(0xFF3B82F6),
    surface: const Color(0xFFF8FAFC), // Replaced background with surface (Material 3)
  ),
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E3A8A),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 24),
    bodyLarge: TextStyle(color: Color(0xFF334155), fontSize: 16),
    bodyMedium: TextStyle(color: Color(0xFF475569), fontSize: 14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1E3A8A),
      foregroundColor: Colors.white,
      elevation: 4,
      shadowColor: const Color(0xFF1E3A8A).withOpacity(0.4),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF1E3A8A),
      side: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFF64748B)),
    prefixIconColor: const Color(0xFF1E3A8A),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
    ),
  ),
);
