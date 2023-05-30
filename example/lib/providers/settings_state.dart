import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

class SettingsState extends ChangeNotifier {
  ColorTheme _theme = ColorTheme.light;
  // bool _isDarkTheme = false;
  // ThemeData _themeData = AppTheme.lightTheme;

  // bool get isDarkTheme => _isDarkTheme;

  ColorTheme get colorTheme => _theme;
  void setColorTheme(ColorTheme theme) {
    // _isDarkTheme = !_isDarkTheme;
    // _themeData = isDarkMode ? AppTheme.dark : AppTheme.light;
    _theme = theme;
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
