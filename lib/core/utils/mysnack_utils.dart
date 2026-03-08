import 'dart:async';

import 'package:flutter/material.dart';


class MysnackUtils {
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void showCustom(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
    Color? textColor,
    ShapeBorder? shape,
  }) {
    _showSnackBar(
      context,
      message,
      backgroundColor: backgroundColor,
      icon: icon,
      textStyle: TextStyle(
        color: textColor ?? Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      shape: shape,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: const Color(0xFFFDEDED), // light red
      icon: Icons.error_outline_rounded,
      textStyle: const TextStyle(
        color: Color(0xFFD32F2F), // deep red
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: const Color(0xFFE8F5E9), // light green
      icon: Icons.check_circle_outline_rounded,
      textStyle: const TextStyle(
        color: Color(0xFF388E3C), // green
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: const Color(0xFFE3F2FD), // light blue
      icon: Icons.info_outline_rounded,
      textStyle: const TextStyle(
        color: Color(0xFF1976D2), // blue
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: const Color(0xFFFFF8E1), // light yellow
      icon: Icons.warning_amber_rounded,
      textStyle: const TextStyle(
        color: Color.fromARGB(255, 151, 117, 30), // yellow
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
    TextStyle? textStyle,
    ShapeBorder? shape,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    _dismissTimer?.cancel();
    _currentEntry?.remove();

    final mediaQuery = MediaQuery.of(context);
    final bottomOffset = mediaQuery.viewPadding.bottom + 96;

    _currentEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 16,
        right: 16,
        bottom: bottomOffset,
        child: IgnorePointer(
          ignoring: true,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: backgroundColor,
                  shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(icon, color: textStyle?.color ?? Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          message,
                          style: textStyle ?? const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_currentEntry!);

    _dismissTimer = Timer(const Duration(seconds: 2), () {
      _currentEntry?.remove();
      _currentEntry = null;
      _dismissTimer = null;
    });
  }
}
