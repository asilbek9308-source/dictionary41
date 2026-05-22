// lib/constants/theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - White & Light Blue
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFF8FBFF);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color accentBlue = Color(0xFFBBDEFB);
  static const Color primaryBlue = Color(0xFF64B5F6);
  static const Color darkBlue = Color(0xFF2196F3);
  static const Color darkText = Color(0xFF1A237E);
  static const Color lightText = Color(0xFF546E7A);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningRed = Color(0xFFEF5350);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: darkText,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      iconTheme: IconThemeData(color: darkText),
    ),
    cardTheme: CardTheme(
      color: primaryWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: primaryBlue.withOpacity(0.1),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: primaryWhite,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: darkText,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        color: darkText,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        color: darkText,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        color: darkText,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      bodyLarge: TextStyle(
        color: darkText,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        color: lightText,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      labelSmall: TextStyle(
        color: lightText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightBlue,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      hintStyle: const TextStyle(
        color: lightText,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.focused)) {
          return primaryBlue;
        }
        return lightText;
      }),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: primaryWhite,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    iconTheme: const IconThemeData(color: darkText),
  );

  // Spacing
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  // Border Radius
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 24;

  // Shadow
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: darkText.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: primaryBlue.withOpacity(0.15),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
