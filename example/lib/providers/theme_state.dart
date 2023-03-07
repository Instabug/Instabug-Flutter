import 'package:flutter/material.dart';

import '../models/app_theme.dart';

class ThemeState with ChangeNotifier {
  bool _isDarkTheme = false;
  ThemeData _themeData = AppTheme.lightTheme;

  bool get isDarkTheme => _isDarkTheme;

  ThemeData getThemeData() => _themeData;
  void setThemeData(bool isDarkMode) {
    _isDarkTheme = !_isDarkTheme;
    _themeData = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    notifyListeners();
  }
}
