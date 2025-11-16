import 'package:flutter/material.dart';

class ThemeConstants {
  // === Theme Colors ===

  // Accent / Primary (Electric Blue)
  static const Color primaryColor = Color(0xFF00A8E8);

  // Backgrounds
  static const Color lightBackground = Colors.white;
  static const Color darkBackground = Color(0xFF0D1117); // Futuristic dark

  // Cards
  static const Color lightCardColor = Colors.white;
  static const Color darkCardColor = Color(0xFF161B22); // Deep navy/graphite

  // Text Colors
  static const Color lightTextColor = Colors.black;
  static const Color darkTextColor = Colors.white;

  // System Status Colors
  static const Color errorColor = Color(0xFFFF5252);
  static const Color successColor = Color(0xFF00C853);
  static const Color warningColor = Color(0xFFFFA000);

  // === Light Theme ===
  static ThemeData get lightTheme => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: lightTextColor,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightBackground,
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF757575),
    ),

    cardColor: lightCardColor,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightTextColor),
      bodyMedium: TextStyle(color: lightTextColor),
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
  );

  // === Dark Theme ===
  static ThemeData get darkTheme => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D1117),
      foregroundColor: darkTextColor,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0D1117),
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFFBDBDBD),
    ),

    cardColor: darkCardColor,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkTextColor),
      bodyMedium: TextStyle(color: darkTextColor),
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
        foregroundColor: darkTextColor,
      ),
    ),
  );
}
