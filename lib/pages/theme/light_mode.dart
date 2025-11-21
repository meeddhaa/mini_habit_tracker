// lib/pages/theme/light_mode.dart
import 'package:flutter/material.dart';

// CRITICAL FIX: Changed to a getter (ThemeData get lightMode) to bypass caching
ThemeData get lightMode => ThemeData(
  brightness: Brightness.light,

  // Color Palette 
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF8C8C8C),       // MUJI warm grey (Used for DrawerHeader, main accents)
    secondary: Color(0xFFE5E2DB),     // Soft beige (Used for interaction backgrounds)
    surface: Colors.white,            // Card/Dialog background
    background: Color(0xFFF7F6F3),    // MUJI off-white (Scaffold background)
    error: Colors.red,
    onPrimary: Colors.white,          // Text color on primary
    onSecondary: Colors.black87,
    onSurface: Colors.black87,
    onBackground: Colors.black87,     // Text color on scaffold
    onError: Colors.white,
  ),

  scaffoldBackgroundColor: const Color(0xFFF7F6F3),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF7F6F3),
    elevation: 0,
    foregroundColor: Colors.black87,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
      letterSpacing: 0.5,
    ),
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: const Color(0xFF8C8C8C),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF5A5A5A),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),
  ),

  // Text Fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFEDEBE7), // warm beige white
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: const Color.fromARGB(255, 210, 187, 141).withOpacity(0.5)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color(0xFFDAD7D1)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color(0xFF8C8C8C), width: 1),
    ),
    hintStyle: const TextStyle(color: Color(0xFF8F8F8F)),
  ),

  // Cards
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFFEAE7E2)),
    ),
  ),

  // Typography
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontSize: 15,
      color: Colors.black87,
      height: 1.5,
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      color: Colors.black87,
      height: 1.5,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
      letterSpacing: 0.5,
    ),
  ),

  dividerColor: const Color(0xFFE0DDD6),
  dividerTheme: const DividerThemeData(
    thickness: 0.8,
    color: Color(0xFFE0DDD6),
  ),
);