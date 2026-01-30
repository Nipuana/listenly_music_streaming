import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/actions/widgets/profile_action_item.dart';

class ProfileActionList extends StatelessWidget {
  const ProfileActionList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.cardColor;
    final primaryColor = theme.colorScheme.primary;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    return Card(
      margin: AppSpacing.px4,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      elevation: 0,
      color: surfaceColor,
      child: ClipRRect(
        borderRadius: AppRadius.xl,
        child: Column(
          children: [
            const ProfileActionItem(icon: Icons.edit, label: 'Edit Profile'),
            const ProfileActionItem(icon: Icons.history, label: 'Listening History'),
            const ProfileActionItem(icon: Icons.favorite_border, label: 'Favorites'),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: AppSpacing.px4.add(AppSpacing.py3),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: AppRadius.lg,
                        ),
                        child: Icon(Icons.bar_chart, color: primaryColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your Stats',
                          style: AppText.bodyMedium.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: textSecondary, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
