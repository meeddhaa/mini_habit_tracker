import 'package:flutter/material.dart';

// Use relative paths to ensure the *current* files are loaded
import 'dark_mode.dart'; 
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // initially set to light mode
  ThemeData _themeData = lightMode;

  // get current theme
  ThemeData get themeData => _themeData;

  // check if dark mode is active
  bool get isDarkMode => _themeData == darkMode;

  // toggle between light and dark mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}