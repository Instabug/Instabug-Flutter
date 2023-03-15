import 'package:flutter/material.dart';

abstract class AppColors {
  static const primaryColor = Color(0xFF00287a);
  static const secondaryColor = Color(0xFF5DAAF0);
  static const primaryColorDark = Color(0xFF212121);
}

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.light,
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryColor,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColor,
      unselectedItemColor: Colors.white,
      selectedItemColor: AppColors.secondaryColor,
    ),
    chipTheme: const ChipThemeData(
      selectedColor: AppColors.secondaryColor,
    ),
    iconTheme: IconThemeData(color: Colors.grey[600]),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Axiforma',
        fontSize: 16.0,
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.secondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryColorDark,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColorDark,
    ),
    chipTheme: const ChipThemeData(
      selectedColor: AppColors.secondaryColor,
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
