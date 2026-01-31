import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final String? error;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscure;
  final VoidCallback? onSuffixTap;
  final TextEditingController controller;

  const AppTextField({
    super.key,
    required this.hint,
    this.error,
    required this.prefixIcon,
    required this.controller,
    this.suffixIcon,
    this.obscure = false,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Use theme-aware colors
    final fillColor = isDark ? AppColors.darkInputFill : AppColors.inputFill;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final iconColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final hintColor = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: textColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return error ?? "$hint cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        prefixIcon: Icon(prefixIcon, color: iconColor),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: iconColor),
              )
            : null,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: AppRadius.xl,
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.xl,
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.xl,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.xl,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.xl,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
