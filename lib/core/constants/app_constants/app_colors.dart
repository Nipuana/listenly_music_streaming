import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // ─────────────────────────────────────────────
  // Primary Colors – Modern Indigo / Blue
  // ─────────────────────────────────────────────
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFF6366F1);

  // Secondary Colors
  static const Color secondary = Color(0xFF3B82F6);
  static const Color secondaryLight = Color(0xFF60A5FA);

  // Accent Colors
  static const Color accent1 = Color(0xFF06B6D4);
  static const Color accent2 = Color(0xFF14B8A6);
  static const Color accent3 = Color(0xFF0EA5E9);

  // ─────────────────────────────────────────────
  // Neutral Colors (Light Bluish Theme)
  // ─────────────────────────────────────────────
  static const Color background = Color(0xFFE8F4FF); // Vibrant blue background
  static const Color backgroundGradientStart = Color(0xFFE0EFFF); // Gradient start
  static const Color backgroundGradientEnd = Color(0xFFF0F8FF); // Gradient end
  static const Color surface = Color(0xFFFFFFFF); // Pure white surface for contrast
  static const Color surfaceVariant = Color(0xFFD6ECFF); // Bright sky blue
  static const Color inputFill = Color(0xFFF5FAFF); // Clean blue-white input

  // ─────────────────────────────────────────────
  // Text Colors
  // ─────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFFCBD5E1);

  // Link Colors
  static const Color link = primary;
  static const Color linkHover = primaryDark;

  // ─────────────────────────────────────────────
  // Border & Divider
  // ─────────────────────────────────────────────
  static const Color border = Color(0xFFB8DAFF); // Vibrant blue border
  static const Color divider = Color(0xFFD1E7FF); // Clear blue divider

  // ─────────────────────────────────────────────
  // Status Colors
  // ─────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Login / Auth
  static const Color authPrimary = secondary;

  // Item Status
  static const Color lostColor = error;
  static const Color foundColor = success;
  static const Color claimedColor = Color(0xFF9E9E9E);

  // ─────────────────────────────────────────────
  // Onboarding Colors
  // ─────────────────────────────────────────────
  static const Color onboarding1Primary = primary;
  static const Color onboarding1Secondary = primaryLight;
  static const Color onboarding2Primary = secondary;
  static const Color onboarding2Secondary = secondaryLight;
  static const Color onboarding3Primary = accent1;
  static const Color onboarding3Secondary = accent2;

  // ─────────────────────────────────────────────
  // White with Opacity
  // ─────────────────────────────────────────────
  static const Color white90 = Color.fromRGBO(255, 255, 255, 0.9);
  static const Color white80 = Color.fromRGBO(255, 255, 255, 0.8);
  static const Color white50 = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color white30 = Color.fromRGBO(255, 255, 255, 0.3);
  static const Color white20 = Color.fromRGBO(255, 255, 255, 0.2);

  // Black with Opacity
  static const Color black20 = Color.fromRGBO(0, 0, 0, 0.2);
  static const Color black10 = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color black05 = Color.fromRGBO(0, 0, 0, 0.05);

  // Text Secondary with Opacity
  static const Color textSecondary60 =
      Color.fromRGBO(100, 116, 139, 0.6);
  static const Color textSecondary50 =
      Color.fromRGBO(100, 116, 139, 0.5);

  // ─────────────────────────────────────────────
  // Gradients
  // ─────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent1, accent2],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundGradientStart, backgroundGradientEnd],
  );
  
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE0EFFF), Color(0xFFF0F8FF), Color(0xFFE8F4FF)],
  );

  // Item Status Gradients
  static const LinearGradient lostGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );

  static const LinearGradient foundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  // Onboarding Gradients
  static const LinearGradient onboarding1Gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient onboarding2Gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  static const LinearGradient onboarding3Gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent1, accent2],
  );

  // ─────────────────────────────────────────────
  // Dark Theme Colors
  // ─────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkInputFill = Color(0xFF1E293B);

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF94A3B8);

  static const Color darkBorder = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF1E293B);
  
  
  // Transparency
  static const Color transparent = Colors.transparent;
}
