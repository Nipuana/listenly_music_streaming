import 'package:flutter/material.dart';

class AppBoxes {
  const AppBoxes._();

  static const BoxShadow cardShadow = BoxShadow(
    color: Color.fromRGBO(79, 70, 229, 0.08),
    offset: Offset(0, 8),
    blurRadius: 24,
    spreadRadius: 0,
  );
  static const BoxShadow buttonShadow = BoxShadow(
    color: Color.fromRGBO(79, 70, 229, 0.25),
    offset: Offset(0, 4),
    blurRadius: 16,
    spreadRadius: 0,
  );
  static const BoxShadow softShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.04),
    offset: Offset(0, 4),
    blurRadius: 12,
    spreadRadius: 0,
  );
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
  static const BoxShadow darkCardShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.15),
    offset: Offset(0, 8),
    blurRadius: 24,
    spreadRadius: 0,
  );
  static const BoxShadow darkSoftShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    offset: Offset(0, 4),
    blurRadius: 12,
    spreadRadius: 0,
  );
}
