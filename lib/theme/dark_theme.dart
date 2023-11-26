import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900]!,
    iconTheme: IconThemeData(color: Colors.grey[300]!),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.grey[900]!,
    primary: Colors.grey[800]!,
    secondary: Colors.grey[700]!,
    inversePrimary: Colors.grey[300]!,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.white),
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.grey[300]!,
    displayColor: Colors.white,
  ),


);
