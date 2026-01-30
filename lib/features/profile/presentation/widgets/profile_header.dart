import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_boxes.dart';
import 'package:weplay_music_streaming/features/profile/presentation/widgets/profile_stat.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  final List<XFile> _selectedMedia = const [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = theme.cardColor;
    final primaryColor = theme.colorScheme.primary;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final cardShadow = isDark ? AppBoxes.darkCardShadow : AppBoxes.cardShadow;
    return Container(
      padding: AppSpacing.py8,
      color: surfaceColor,
      child: Column(
        children: [
          // Avatar
          Container(
            width: AppSpacing.size20,
            height: AppSpacing.size20,
            decoration: BoxDecoration(
              borderRadius: AppRadius.full,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.3),
                width: 3,
              ),
              boxShadow: [
                cardShadow,
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: AppRadius.full,
              ),
              alignment: Alignment.center,
              child: Text(
                'JD',
                style: AppText.headline.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AppSpacing.gap4,
          // Name
          Text(
            'John Doe',
            style: AppText.headline.copyWith(
              color: textPrimary,
              fontSize: 20,
            ),
          ),
          AppSpacing.gap2,
          // Email
          Text(
            'john.doe@email.com',
            style: AppText.body.copyWith(
              color: textSecondary,
              fontSize: 14,
            ),
          ),
          AppSpacing.gap6,
          // Stats Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileStat(count: '125', label: 'Liked Songs'),
              ProfileStat(count: '8', label: 'Playlists'),
              ProfileStat(count: '45', label: 'Following'),
            ],
          ),
        ],
      ),
    );
  }
}
