import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/actions/widgets/profile_action_item.dart';

class ProfileSettingsList extends StatelessWidget {
  final VoidCallback? onChangePassword;
  final VoidCallback? onOpenSupport;

  const ProfileSettingsList({
    super.key,
    this.onChangePassword,
    this.onOpenSupport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.cardColor;
    return Card(
      margin: AppSpacing.px4,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      elevation: 0,
      color: surfaceColor,
      child: ClipRRect(
        borderRadius: AppRadius.xl,
        child: Column(
          children: [
            ProfileActionItem(
              icon: Icons.lock_outline,
              label: 'Change Password',
              onTap: onChangePassword,
            ),
            ProfileActionItem(
              icon: Icons.help_outline_rounded,
              label: 'Support & FAQ',
              onTap: onOpenSupport,
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}
