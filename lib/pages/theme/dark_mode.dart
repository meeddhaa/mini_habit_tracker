// lib/pages/theme/dark_mode.dart
import 'package:flutter/material.dart';

// 🛑 CRITICAL FIX: Changed from 'ThemeData darkMode = ...' to a getter
ThemeData get darkMode => ThemeData(
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF3A3A3A),        // MUJI charcoal grey
    secondary: Color(0xFF4A4A4A),      // soft muted grey
    surface: Color(0xFF2B2B2B),        // warm dark surface
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    brightness: Brightness.dark,
  ),

  //  AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  //  Elevated Buttons 
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4A4A4A), // muted charcoal
      foregroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
  ),

  //  Scaffold Background
  scaffoldBackgroundColor: const Color(0xFF1F1F1F), // MUJI
);