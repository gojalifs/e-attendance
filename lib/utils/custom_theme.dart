import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData themeData = ThemeData(
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 50),
      bodyMedium: TextStyle(fontSize: 18, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 15, color: Colors.black87),
      titleLarge: TextStyle(fontSize: 33),
      titleMedium: TextStyle(fontSize: 25),
      titleSmall: TextStyle(fontSize: 17),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      labelStyle: const TextStyle(fontSize: 20),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        // backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: CustomColor.customColor,
      accentColor: CustomColor.customAccentColor,
    ),
    appBarTheme: const AppBarTheme(
      toolbarHeight: 100,
      titleTextStyle: TextStyle(fontSize: 30, color: Colors.black),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(fontSize: 10), menuStyle: MenuStyle()),
  );
}

class CustomColor {
  static MaterialColor customColor =
      const MaterialColor(0xFF24DB7A, <int, Color>{
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  });

  static MaterialColor customAccentColor =
      const MaterialColor(0xFFDBD624, <int, Color>{
    50: Color.fromRGBO(219, 214, 36, .1),
    100: Color.fromRGBO(219, 214, 36, .2),
    200: Color.fromRGBO(219, 214, 36, .3),
    300: Color.fromRGBO(219, 214, 36, .4),
    400: Color.fromRGBO(219, 214, 36, .5),
    500: Color.fromRGBO(219, 214, 36, .6),
    600: Color.fromRGBO(219, 214, 36, .7),
    700: Color.fromRGBO(219, 214, 36, .8),
    800: Color.fromRGBO(219, 214, 36, .9),
    900: Color.fromRGBO(219, 214, 36, 1),
  });
}
