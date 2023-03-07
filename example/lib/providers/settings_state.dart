import 'package:flutter/material.dart';

class SettingsState extends ChangeNotifier {
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
