import 'package:flutter/widgets.dart';

class AppSpacing {
  // Base spacing (px)

  static const double x2 = 8;  
  static const double x4 = 16;  
  //card padding
  static const double x6 = 24;  
  // section padding
  static const double x8 = 32; 
    
  // Directional padding
  static const EdgeInsets px4 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets px6 = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets px12 = EdgeInsets.symmetric(horizontal: 48);

  static const EdgeInsets py2 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets py3 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets py4 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets py8 = EdgeInsets.symmetric(vertical: 32);
  
  // Margins
  static const EdgeInsets m4 = EdgeInsets.all(16);

  static const EdgeInsets mb1 = EdgeInsets.only(bottom: 4);
  static const EdgeInsets mb3 = EdgeInsets.only(bottom: 12);
  static const EdgeInsets mb4 = EdgeInsets.only(bottom: 16);
  static const EdgeInsets mb6 = EdgeInsets.only(bottom: 24);
  static const EdgeInsets mb8 = EdgeInsets.only(bottom: 32);

  static const EdgeInsets mt4 = EdgeInsets.only(top: 16);
  static const EdgeInsets mt6 = EdgeInsets.only(top: 24);
  static const EdgeInsets mt8 = EdgeInsets.only(top: 32);

    
  // Gaps (SizedBox helpers)
    

  static const SizedBox gap2 = SizedBox(height: 8);
  static const SizedBox gap3 = SizedBox(height: 12);
  static const SizedBox gap4 = SizedBox(height: 16);
  static const SizedBox gap6 = SizedBox(height: 24);

  // Horizontal gaps
  static const SizedBox hGap2 = SizedBox(width: 8);
  static const SizedBox hGap3 = SizedBox(width: 12);
  static const SizedBox hGap4 = SizedBox(width: 16);

    
  // Common vertical spacing
  static const double spaceY3 = 12; // space-y-3
  static const double spaceY4 = 16; // space-y-4
  static const double spaceY6 = 24; // space-y-6

    
  // Sizes (width / height)
  static const double size10 = 40; // w-10 / h-10
  static const double size12 = 48; // w-12 / h-12
  static const double size16 = 64; // w-16 / h-16
  static const double size20 = 80; // w-20 / h-20
  static const double size24 = 96; // w-24 / h-24
}
