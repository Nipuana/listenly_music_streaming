import 'package:flutter/widgets.dart';

class AppRadius {
  static const double base = 10; // --radius

  static const BorderRadius lg =
      BorderRadius.all(Radius.circular(8)); // rounded-lg

  static const BorderRadius xl =
      BorderRadius.all(Radius.circular(12)); // rounded-xl

  static const BorderRadius x2l =
      BorderRadius.all(Radius.circular(16)); // rounded-2xl

  static const BorderRadius x3l =
      BorderRadius.all(Radius.circular(24)); // rounded-3xl

  static const BorderRadius full =
      BorderRadius.all(Radius.circular(9999)); // rounded-full
}
