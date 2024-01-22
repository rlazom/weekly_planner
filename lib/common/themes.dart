import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: R.colors.appPrimaryColor,
  colorScheme: ColorScheme.fromSwatch(
    accentColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  fontFamily: 'Quicksand',
  textTheme: const TextTheme(
    headlineMedium: TextStyle(color: Colors.white),
    headlineLarge: TextStyle(
      fontSize: 50.0,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF009FE3),
    ),
    bodyMedium: TextStyle(fontSize: 14.0, fontStyle: FontStyle.normal),
  ),
);
