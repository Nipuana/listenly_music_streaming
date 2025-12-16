import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_colors.dart';
import 'package:weplay_music_streaming/constant/app_radius.dart';

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

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return error ?? "$hint cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(prefixIcon, color: theme.iconTheme.color),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: theme.iconTheme.color),
              )
            : null,
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: AppRadius.xl,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.xl,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.xl,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
