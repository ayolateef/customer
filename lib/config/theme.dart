import 'package:flutter/material.dart';

class AppThemeData {
  //
  // Dark mode flag
  //
  bool darkMode = false;
  //
  // colors
  //
  Color colorGrey = Color.fromARGB(255, 209, 210, 205);

  Color colorPrimary = Color(0xff009688);
  Color colorCompanion = Color(0xff374137);
  Color colorCompanion2 = Color(0xffffbb43);
  Color colorCompanion3 = Color(0xffb6e9d1);
  Color colorCompanion4 = Colors.green;

  late Color colorBackground;
  late Color colorBackgroundGray;
  late Color colorDefaultText;
  late Color colorBackgroundDialog;
  late MaterialColor primarySwatch;
  List<Color> colorsGradient = [];
  Color colorDarkModeLight =
      Color.fromARGB(255, 40, 40, 40); // for dialog background in dark mode

  //
  late TextStyle text10white;
  late TextStyle text12bold;
  late TextStyle text12grey;
  late TextStyle text14;
  late TextStyle text14primary;
  late TextStyle text14purple;
  late TextStyle text14grey;
  late TextStyle text14bold;
  late TextStyle text14boldPimary;
  late TextStyle text14boldWhite;
  late TextStyle text14boldWhiteShadow;
  late TextStyle text16;
  late TextStyle text16bold;
  late TextStyle text16boldWhite;
  late TextStyle text18boldPrimary;
  late TextStyle text18bold;
  late TextStyle text20;
  late TextStyle text20bold;
  late TextStyle text20boldPrimary;
  late TextStyle text20boldWhite;
  late TextStyle text20negative;
  late TextStyle text22primaryShadow;

  changeDarkMode() {
    darkMode = !darkMode;
    init();
  }

  init() {
    if (darkMode) {
      colorBackground = _backgroundDarkColor;
      colorDefaultText = _backgroundColor;
      colorBackgroundGray = Colors.white.withOpacity(0.1);
      primarySwatch = black;
      colorBackgroundDialog = colorDarkModeLight;
      Color _color2 = Color.fromARGB(80, 80, 80, 80);
      colorsGradient = [_color2, Colors.white];
    } else {
      Color _color2 = Color.fromARGB(
          80, colorPrimary.red, colorPrimary.green, colorPrimary.blue);
      colorsGradient = [_color2, colorPrimary];
      colorBackgroundDialog = _backgroundColor;
      colorBackgroundGray = Colors.black.withOpacity(0.01);
      colorBackground = _backgroundColor;
      colorDefaultText = _backgroundDarkColor;
      primarySwatch = white;
    }

    text10white = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 10,
    );

    text12bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 12,
    );

    text12grey = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    text14 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14primary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14purple = TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
    text14bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14boldPimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14grey = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14boldWhiteShadow = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 14,
        shadows: [
          Shadow(offset: Offset(1, 1), color: Colors.black, blurRadius: 1),
        ]);

    text16bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    text18boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text18bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text20bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text20boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20negative = TextStyle(
      // text negative color
      color: colorBackground,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text22primaryShadow = TextStyle(
        // text negative color
        color: colorPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 22,
        shadows: [
          Shadow(offset: Offset(1, 1), color: Colors.black, blurRadius: 1),
        ]);
  }
}

//
// Colors
//
var _backgroundColor = Colors.white;
var _backgroundDarkColor = Colors.black;

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

const MaterialColor black = const MaterialColor(
  0xFF000000,
  const <int, Color>{
    50: const Color(0xFF000000),
    100: const Color(0xFF000000),
    200: const Color(0xFF000000),
    300: const Color(0xFF000000),
    400: const Color(0xFF000000),
    500: const Color(0xFF000000),
    600: const Color(0xFF000000),
    700: const Color(0xFF000000),
    800: const Color(0xFF000000),
    900: const Color(0xFF000000),
  },
);
