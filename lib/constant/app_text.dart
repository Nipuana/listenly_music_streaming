import 'package:flutter/material.dart';

class AppText {
  static const String fontFamily = 'Roboto';

  static const double baseFontSize = 16;
  static const double lineHeight = 1.5;

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: baseFontSize,
    fontWeight: regular,
    height: lineHeight,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: baseFontSize,
    fontWeight: medium,
    height: lineHeight,
  );

  static const TextStyle small = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: lineHeight,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: medium,
    height: lineHeight,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: bold,
    height: lineHeight,
  );
}
