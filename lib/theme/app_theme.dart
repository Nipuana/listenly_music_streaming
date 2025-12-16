import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_colors.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',

    // Scaffold Background
    scaffoldBackgroundColor: AppColors.background,

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),

      
    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),

      
    // Text
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    ),

      
    // Icons
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
    ),
      
    // Dividers
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
    ),

    // Snackbars      
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surface,
      contentTextStyle: const TextStyle(
        color: AppColors.textPrimary,
      ),
      actionTextColor: AppColors.link,
    ),
  );
}
