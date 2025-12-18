import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_radius.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? icon;
  final bool expanded;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 50,
      width: expanded ? double.infinity : null,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon ?? const SizedBox.shrink(),
        label: Text(
          text,
          style: AppText.bodyMedium.copyWith(
            color: foregroundColor ?? theme.colorScheme.onPrimary,
            fontWeight: AppText.medium,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
          elevation: 0,
        ),
      ),
    );
  }
}
