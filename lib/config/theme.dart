import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Neon cyberpunk color palette
const Color neonCyan = Color(0xFF00FFD0);
const Color neonRed = Color(0xFFFF3B3B);
const Color bgDark = Color(0xFF050505);
const Color textElite = Color(0xFFB0B0B0);
const Color goldBadge = Color(0xFFFFD700);
const Color silverBadge = Color(0xFFC0C0C0);
const Color bronzeBadge = Color(0xFFCD7F32);
const Color neonGreen = Color(0xFF39FF14);
const Color glassWhite = Color(0x1AFFFFFF);

ThemeData buildZigclipTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDark,
    primaryColor: neonCyan,
    colorScheme: const ColorScheme.dark(
      primary: neonCyan,
      secondary: neonRed,
      surface: bgDark,
      error: neonRed,
    ),
    textTheme: GoogleFonts.courierPrimeTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: neonCyan,
          letterSpacing: 2,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: neonCyan,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textElite,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textElite,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textElite,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: neonCyan,
          letterSpacing: 1.5,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: glassWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: neonCyan.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
