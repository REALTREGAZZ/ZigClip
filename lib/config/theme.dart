import 'package:flutter/material.dart';

class AppColors {
  static const darkBg = Color(0xFF050505);
  static const neonCyan = Color(0x00FFD0FF);
  static const neonRed = Color(0xFFFF3B3B);
  static const textElite = Color(0xFFB0B0B0);
  
  static const glassBg = Color(0x1AFFFFFF);
  static const glassBorder = Color(0x33FFFFFF);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.neonCyan,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonCyan,
        secondary: AppColors.neonRed,
        surface: AppColors.darkBg,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: AppColors.textElite,
          fontFamily: 'monospace',
        ),
        bodyMedium: TextStyle(
          color: AppColors.textElite,
          fontFamily: 'monospace',
        ),
        displayLarge: TextStyle(
          color: Colors.white,
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        displayMedium: TextStyle(
          color: AppColors.textElite,
          fontFamily: 'monospace',
          fontSize: 24,
        ),
        displaySmall: TextStyle(
          color: AppColors.textElite,
          fontFamily: 'monospace',
          fontSize: 18,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.glassBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
      ),
    );
  }
  
  static BoxDecoration get glassBox {
    return BoxDecoration(
      color: AppColors.glassBg,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.glassBorder,
        width: 1,
      ),
    );
  }
  
  static BoxShadow get neonGlow {
    return BoxShadow(
      color: AppColors.neonCyan.withValues(alpha: 0.5),
      blurRadius: 20,
      spreadRadius: 5,
    );
  }
}
