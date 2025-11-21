// lib/pages/theme/theme_provider.dart
import 'package:flutter/material.dart';

import 'dark_mode.dart'; 
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Accesses the 'lightMode' getter for a fresh Theme object
  ThemeData _themeData = lightMode;

  // Get current theme
  ThemeData get themeData => _themeData;

  // 🛑 FIX: Use brightness property for the most reliable theme check
  bool get isDarkMode => _themeData.brightness == Brightness.dark;

  // Toggle theme
  void toggleTheme() {
    // 🛑 FIX: Check the brightness property to determine the current state
    if (_themeData.brightness == Brightness.light) {
      _themeData = darkMode; // Accesses the darkMode getter (fresh object)
    } else {
      _themeData = lightMode; // Accesses the lightMode getter (fresh object)
    }
    notifyListeners(); // Notify listeners after changing the theme
  }
}