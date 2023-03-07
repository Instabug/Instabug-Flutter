import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.light,
      primary: const Color(0xFF00287a),
      secondary: const Color(0xFF5DAAF0),
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      color: Color(0xFF00287a),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF00287a),
      unselectedItemColor: Colors.white,
      selectedItemColor: Color(0xFF5DAAF0),
    ),
    chipTheme: const ChipThemeData(
      selectedColor: Color(0xFF5DAAF0),
    ),
    iconTheme: IconThemeData(color: Colors.grey[600]),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Axiforma',
        fontSize: 16.0,
        color: Color(0xFF00287a),
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF5DAAF0),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF212121),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF212121),
    ),
    chipTheme: const ChipThemeData(
      selectedColor: Color(0xFF5DAAF0),
      backgroundColor: Color(0xFFB3B3B3),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Axiforma',
        fontSize: 16.0,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
