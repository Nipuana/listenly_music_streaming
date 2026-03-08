import 'package:flutter/material.dart';

class ResponsiveUtils {
  /// Get screen width
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if device is mobile (width < 600)
  static bool isMobile(BuildContext context) {
    return getWidth(context) < 600;
  }

  /// Check if device is tablet (600 <= width < 1024)
  static bool isTablet(BuildContext context) {
    final width = getWidth(context);
    return width >= 600 && width < 1024;
  }

  /// Check if device is desktop (width >= 1024)
  static bool isDesktop(BuildContext context) {
    return getWidth(context) >= 1024;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 40, vertical: 24);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  }

  /// Get responsive horizontal padding only
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 40);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    return const EdgeInsets.symmetric(horizontal: 20);
  }

  /// Get responsive card width for grid layout
  static double getCardWidth(BuildContext context, {int columns = 2}) {
    final width = getWidth(context);
    final padding = getResponsiveHorizontalPadding(context).horizontal;
    final spacing = 16.0 * (columns - 1);
    return (width - padding - spacing) / columns;
  }

  /// Get responsive grid cross axis count
  static int getGridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) {
      return 4;
    } else if (isTablet(context)) {
      return 3;
    }
    return 2;
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    if (isDesktop(context)) {
      return baseFontSize * 1.2;
    } else if (isTablet(context)) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context, double baseIconSize) {
    if (isDesktop(context)) {
      return baseIconSize * 1.3;
    } else if (isTablet(context)) {
      return baseIconSize * 1.15;
    }
    return baseIconSize;
  }

  /// Get responsive card elevation
  static double getResponsiveElevation(BuildContext context) {
    if (isDesktop(context)) {
      return 4;
    } else if (isTablet(context)) {
      return 2;
    }
    return 0;
  }

  /// Get max content width for large screens
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1200;
    }
    return double.infinity;
  }

  /// Center content on large screens
  static Widget centerContent(BuildContext context, Widget child) {
    if (isDesktop(context)) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: getMaxContentWidth(context)),
          child: child,
        ),
      );
    }
    return child;
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    if (isDesktop(context)) {
      return baseSpacing * 1.5;
    } else if (isTablet(context)) {
      return baseSpacing * 1.25;
    }
    return baseSpacing;
  }

  /// Get responsive bottom padding (for nav bar and playbar)
  static double getBottomPadding(BuildContext context) {
    if (isDesktop(context)) {
      return 200;
    } else if (isTablet(context)) {
      return 180;
    }
    return 160;
  }
}
