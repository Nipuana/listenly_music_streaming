import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';

class AppSocialButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? assetIcon;
  final VoidCallback onPressed;
  final double iconSize;
  final Color? iconColor;

  const AppSocialButton({
    super.key,
    required this.text,
    this.icon,
    this.assetIcon,
    required this.onPressed,
    this.iconSize = 20,
    this.iconColor,
  }) : assert(icon != null || assetIcon != null, 'Either icon or assetIcon must be provided');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final bgColor = isDark ? AppColors.darkInputFill : AppColors.inputFill;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    
    // Determine icon color based on icon type
    Color getIconColor() {
      if (iconColor != null) return iconColor!;
      if (icon == FontAwesomeIcons.apple || icon == Icons.apple) {
        return isDark ? Colors.white : Colors.black;
      }
      return textColor;
    }

    Widget buildIcon() {
      if (assetIcon != null) {
        return SizedBox(
          height: iconSize,
          width: iconSize,
          child: Center(
            child: Image.asset(
              assetIcon!,
              height: iconSize,
              width: iconSize,
              fit: BoxFit.contain,
            ),
          ),
        );
      }
      return SizedBox(
        height: iconSize,
        width: iconSize,
        child: Center(
          child: Icon(icon, size: iconSize, color: getIconColor()),
        ),
      );
    }

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.xl,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildIcon(),
            const SizedBox(width: 12),
            Text(
              text,
              style: AppText.bodyMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
