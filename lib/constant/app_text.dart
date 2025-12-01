
import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_colors.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
       color: AppColors.primary,
  );
}