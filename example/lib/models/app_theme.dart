import 'package:flutter/material.dart';

abstract class AppColors {
  static const primary = Color(0xFF00287a);
  static const secondary = Color(0xFF5DAAF0);
  static const primaryDark = Color(0xFF212121);
}

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      color: AppColors.primary,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primary,
      unselectedItemColor: Colors.white,
      selectedItemColor: AppColors.secondary,
    ),
    chipTheme: const ChipThemeData(
      selectedColor: AppColors.secondary,
    ),
    iconTheme: IconThemeData(color: Colors.grey[600]),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Axiforma',
        fontSize: 16.0,
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.secondary,
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryDark,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryDark,
    ),
    chipTheme: const ChipThemeData(
      selectedColor: AppColors.secondary,
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
