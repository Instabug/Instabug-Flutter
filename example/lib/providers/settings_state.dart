import 'package:flutter/material.dart';

import '../models/app_theme.dart';

class SettingsState extends ChangeNotifier {
  bool _isDarkTheme = false;
  ThemeData _themeData = AppTheme.lightTheme;

  bool get isDarkTheme => _isDarkTheme;

  ThemeData getThemeData() => _themeData;
  void setThemeData(bool isDarkMode) {
    _isDarkTheme = !_isDarkTheme;
    _themeData = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    notifyListeners();
  }

  final Map<String, Color> _colors = {
    'Default': const Color(0xFF1D82DC),
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Yellow': Colors.yellow,
    'Orange': Colors.orange,
    'Purple': Colors.purple,
    'Pink': Colors.pink,
  };

  String _selectedColorName = 'Default';

  Map<String, Color> get colors => _colors;

  Color get selectedColor => _colors[_selectedColorName]!;

  String get selectedColorName => _selectedColorName;
  void selectColor(String colorName) {
    _selectedColorName = colorName;
    notifyListeners();
  }
}
