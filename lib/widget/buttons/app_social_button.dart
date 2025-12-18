import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_colors.dart';
import 'package:weplay_music_streaming/constant/app_radius.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';

class AppSocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const AppSocialButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: AppColors.textPrimary),
        label: Text(
          text,
          style: AppText.bodyMedium.copyWith(color: AppColors.textPrimary),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.inputBackground,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.xl,
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}
