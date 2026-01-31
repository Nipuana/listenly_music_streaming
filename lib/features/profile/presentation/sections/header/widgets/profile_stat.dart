import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';

class ProfileStat extends StatelessWidget {
  final String count;
  final String label;

  const ProfileStat({
    super.key,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
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
