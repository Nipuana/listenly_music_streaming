import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/actions/widgets/profile_action_item.dart';

class ProfileActionList extends StatelessWidget {
  final VoidCallback? onEditProfile;
  final VoidCallback? onVerifyAsArtist;

  const ProfileActionList({
    super.key,
    this.onEditProfile,
    this.onVerifyAsArtist,
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
              icon: Icons.edit,
              label: 'Edit Profile',
              onTap: onEditProfile,
            ),
            ProfileActionItem(
              icon: Icons.verified_outlined,
              label: 'Verify as Artist',
              onTap: onVerifyAsArtist,
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}
