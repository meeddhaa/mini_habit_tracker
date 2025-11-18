import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  // 1. Updated ColorScheme for deep contrast and violet branding
  colorScheme: ColorScheme.dark(
    // Surface: Deep Charcoal/Near Black for a true dark mode feel
    surface: const Color(0xFF121212), 
    
    // Primary: Background for main containers/headers (slightly lighter charcoal)
    primary: const Color(0xFF1F1F1F), 
    
    // Secondary: Background for interactive tiles (Habit Tile background)
    secondary: const Color(0xFF2C2C2C), // Medium contrast gray
    
    // Tertiary: ACCENT COLOR (The bright violet from the light theme)
    tertiary: const Color(0xFF8B5CF6), // Bright Violet/Purple
    
    // Inverse Primary: Light text/icons that stand out on dark surfaces
    inversePrimary: const Color(0xFFEFEFEF), // Light Off-White for text
    
    // Optional: Error color (keep standard red for warnings)
    error: const Color(0xFFCF6679), 
  ),

  // 2. Aesthetic Refinement: Rounded Shapes
  cardTheme: CardTheme(
    elevation: 0, // Keep cards flat in dark mode for a sleek look
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0), // Consistent soft corners
    ),
  ),
  
  // 3. Aesthetic Refinement: Button Styling
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Consistent soft corners
      ),
      elevation: 0, // Flat buttons look cleaner
      // Use the accent color for buttons
      backgroundColor: const Color(0xFF8B5CF6), 
      foregroundColor: Colors.white,
    ),
  ),
  
  // 4. Aesthetic Refinement: Input Fields
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0), // Rounded corners for text fields
      borderSide: BorderSide.none,
    ),
    fillColor: const Color(0xFF2C2C2C), // Dark fill color for input background
    filled: true,
  ),
);