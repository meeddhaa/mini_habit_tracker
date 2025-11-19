import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,

  //  Color Palette 
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF8C8C8C),       // MUJI warm grey
    secondary: const Color(0xFFE5E2DB),     // Soft beige (linen tone)
    surface: Colors.white,
    background: const Color(0xFFF7F6F3),    // MUJI off-white
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.black87,
    onSurface: Colors.black87,
    onBackground: Colors.black87,
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
      backgroundColor: Color(0xFF8C8C8C),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFF5A5A5A),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),
  ),

  // Text Fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFEDEBE7), // warm beige white
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color(0xFFDAD7D1)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color(0xFFDAD7D1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color(0xFF8C8C8C), width: 1),
    ),
    hintStyle: TextStyle(color: Color(0xFF8F8F8F)),
  ),

  // Cards
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Color(0xFFEAE7E2)),
    ),
  ),

  // Typography
  textTheme: TextTheme(
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
  dividerTheme: DividerThemeData(
    thickness: 0.8,
    color: Color(0xFFE0DDD6),
  ),
);
