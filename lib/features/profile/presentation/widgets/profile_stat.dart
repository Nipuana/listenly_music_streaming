import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';

class ProfileStat extends StatelessWidget {
  final String count;
  final String label;
  final Color primaryColor;
  final Color textSecondary;

  const ProfileStat({
    super.key,
    required this.count,
    required this.label,
    required this.primaryColor,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.px4,
      child: Column(
        children: [
          Text(
            count,
            style: AppText.headline.copyWith(
              color: primaryColor,
              fontSize: 18,
            ),
          ),
          AppSpacing.gap2,
          Text(
            label,
            style: AppText.small.copyWith(
              color: textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
