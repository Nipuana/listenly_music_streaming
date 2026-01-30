import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';

class ProfileActionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const ProfileActionItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    return Column(
      children: [
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
                    child: Icon(icon, color: primaryColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
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
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.x4 + 40 + 12),
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: textSecondary.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}
