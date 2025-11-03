import 'package:flutter/material.dart';
import 'package:mini_habit_tracker/pages/theme/dark_mode.dart';

import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //initially set to light mode
  ThemeData _themeData = lightMode;

  //get the curent theme
  ThemeData getTheme() => _themeData;

  //is dark mode ?
  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toggle between light and dark mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
  }
}
