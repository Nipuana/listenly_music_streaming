import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.cardColor;
    final errorColor = theme.colorScheme.error;
    return Padding(
      padding: AppSpacing.px4,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
        elevation: 0,
        color: surfaceColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: AppRadius.xl,
            child: Padding(
              padding: AppSpacing.px4.add(AppSpacing.py3),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: errorColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.lg,
                    ),
                    child: Icon(Icons.logout, color: errorColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Logout',
                      style: AppText.bodyMedium.copyWith(
                        color: errorColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: errorColor.withValues(alpha: 0.5), size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
