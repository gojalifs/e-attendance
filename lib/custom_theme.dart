import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData themeData = ThemeData(
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 50),
      bodyMedium: TextStyle(fontSize: 18),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red,
    ),
  );
}
