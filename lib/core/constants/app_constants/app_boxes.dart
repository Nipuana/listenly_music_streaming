import 'package:flutter/material.dart';

class AppBoxes {
  const AppBoxes._();

  // Card Shadow
  static const BoxShadow cardShadow = BoxShadow(
    color: Color.fromRGBO(79, 70, 229, 0.08),
    offset: Offset(0, 8),
    blurRadius: 24,
    spreadRadius: 0,
  );

  // Button Shadow
  static const BoxShadow buttonShadow = BoxShadow(
    color: Color.fromRGBO(79, 70, 229, 0.25),
    offset: Offset(0, 4),
    blurRadius: 16,
    spreadRadius: 0,
  );

  // Soft Shadow
  static const BoxShadow softShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.04),
    offset: Offset(0, 4),
    blurRadius: 12,
    spreadRadius: 0,
  );

  // Elevated Shadow (multiple shadows)
  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      offset: Offset(0, 15),
      blurRadius: 30,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.2),
      offset: Offset(0, 5),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  // Dark Card Shadow
  static const BoxShadow darkCardShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.15),
    offset: Offset(0, 8),
    blurRadius: 24,
    spreadRadius: 0,
  );

  // Dark Soft Shadow
  static const BoxShadow darkSoftShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    offset: Offset(0, 4),
    blurRadius: 12,
    spreadRadius: 0,
  );

  // --- Additional Shadow Utilities ---

  // shadowSm: 0 1px 2px rgba(0, 0, 0, 0.05)
  static const BoxShadow shadowSm = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.05),
    offset: Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  );

  // shadowMd
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  // shadowLg
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  // shadowXl
  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 10),
      blurRadius: 10,
      spreadRadius: -5,
    ),
  ];

  // No Shadow
  static const List<BoxShadow> noShadow = [];
}
