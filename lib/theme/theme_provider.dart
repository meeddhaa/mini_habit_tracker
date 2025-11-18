import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/pages/theme/dark_mode.dart';
import 'package:mini_habit_tracker/pages/theme/light_mode.dart';

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
