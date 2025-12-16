import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){
  return ThemeData(
        fontFamily: "Roboto",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(5)
          )
        )
    );
}