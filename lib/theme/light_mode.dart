import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  // 1. Updated ColorScheme for a softer, modern look
  colorScheme: ColorScheme.light(
    // Surface: Near white, but slightly warm off-white (less harsh than pure white)
    surface: const Color(0xFFF7F7F7), 
    
    // Primary: Soft background for large elements (e.g., Drawer Header, Card outlines)
    primary: const Color(0xFFE6E0F8), // Soft Lavender
    
    // Secondary: Background for interactive elements/tiles (Habit Tile background)
    secondary: const Color(0xFFFFFFFF), // White for separation
    
    // Tertiary: ACCENT COLOR (Used for FAB, checkmarks, highlights)
    tertiary: const Color(0xFF8B5CF6), // Bright, noticeable Purple/Violet
    
    // Inverse Primary: Dark text/icons that stand out on light surfaces
    inversePrimary: const Color(0xFF333333), // Dark Gray/Black for text
  ),

  // 2. Aesthetic Refinement: Rounded Shapes
  cardTheme: CardTheme(
    elevation: 1, // Subtle lift
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0), // Soft, modern corners for cards/tiles
    ),
  ),
  
  // 3. Aesthetic Refinement: Button Styling
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Soft corners for buttons
      ),
      elevation: 0, // Flat buttons look cleaner in modern UIs
    ),
  ),
  
  // 4. Aesthetic Refinement: Input Fields
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0), // Rounded corners for text fields
      borderSide: BorderSide.none,
    ),
    fillColor: const Color(0xFFEBEBEB), // Light fill color for input background
    filled: true,
  ),
);