import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){
  return ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: "Roboto"
            ),
            backgroundColor: CupertinoColors.systemBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            )
          )
        ),
    );
}