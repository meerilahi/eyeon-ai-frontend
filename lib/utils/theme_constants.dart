import 'package:flutter/material.dart';

class ThemeConstants {
  // === Theme Colors ===

  // Accent / Primary (Security Red)
  static const Color primaryColor = Colors.red;

  // Backgrounds
  static const Color backgroundColor = Colors.white;

  // Cards
  static const Color cardColor = Colors.white;

  // Text Colors
  static const Color textColor = Colors.black;

  // System Status Colors
  static const Color errorColor = Color(0xFFFF5252);
  static const Color successColor = Color(0xFF00C853);
  static const Color warningColor = Color(0xFFFFA000);

  // === Light Theme ===
  static ThemeData get lightTheme => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF757575),
    ),

    cardColor: cardColor,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),

    drawerTheme: const DrawerThemeData(backgroundColor: backgroundColor),
  );
}

// #2596be dart cayn

// #1b1b1b black

// #1b1b1b black 2
