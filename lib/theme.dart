import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ThemeData kLightTheme = _buildLightTheme();

ThemeData _buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
//    accentColor: Color(0xFF000000),
    primaryColor: Color(0xFFF5F5F5),
    scaffoldBackgroundColor: Color(0xFFF2F2F7),
//    primaryColorLight: Color(0xFFFFFFFF),
    backgroundColor: Color(0xFFFFFFFF),
    canvasColor: Color(0xFFF5F5F5),
    cardColor: Color(0xFFFFFFFF),
    hintColor: Color(0xFFA8A8AB),
    appBarTheme: AppBarTheme(
      elevation: 0.6,
      color: Color(0xFFF8F8F8),
      brightness: Brightness.light,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF000000),
    ),
    dividerTheme: DividerThemeData(
      thickness: 0.6,
    ),
  );
}

final ThemeData kDarkTheme = _buildDarkTheme();

ThemeData _buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
//    accentColor: Color(0xFF1B1C1E),
    primaryColor: Color(0xFF1B1C1E),
//    primaryColorLight: Color(0xFF1B1C1E),
    scaffoldBackgroundColor: Color(0xFF000000),
    backgroundColor: Color(0xFF1C1C1E),
    cardColor: Color(0xFF000000),
    canvasColor: Color(0xFF000000),
    hintColor: Color(0xFF919197),
    appBarTheme: AppBarTheme(
      elevation: 0.6,
      color: Color(0xFF1B1C1E),
      brightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFFFFFFFF),
    ),
    dividerTheme: DividerThemeData(
      thickness: 0.6,
    ),
    textTheme: TextTheme(
      headline6: TextStyle().copyWith(color: Color(0xFFF5F5F5)),
      subtitle1: TextStyle().copyWith(color: Color(0xFFF5F5F5)),
    ),
  );
}
