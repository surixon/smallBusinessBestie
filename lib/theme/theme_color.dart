import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData? activeTheme;

final mainTheme = ThemeData(
    primaryColor: const Color(0xFF0294EA),
    primaryColorLight: const Color(0xFF0294EA),
    useMaterial3: false,

    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0294EA),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        )),
    primarySwatch: colorBlack,
    brightness: Brightness.light);

MaterialColor colorBlack = const MaterialColor(0xFF0294EA, <int, Color>{
  50: Color(0xFF0294EA),
  100: Color(0xFF0294EA),
  200: Color(0xFF0294EA),
  300: Color(0xFF0294EA),
  400: Color(0xFF0294EA),
  500: Color(0xFF0294EA),
  600: Color(0xFF0294EA),
  700: Color(0xFF0294EA),
  800: Color(0xFF0294EA),
  900: Color(0xFF0294EA),
});
