import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_boxes.dart';
import 'package:weplay_music_streaming/features/profile/presentation/widgets/profile_header.dart';
import 'package:weplay_music_streaming/features/profile/presentation/widgets/profile_action_list.dart';
import 'package:weplay_music_streaming/features/profile/presentation/widgets/profile_settings_list.dart';
import 'package:weplay_music_streaming/features/profile/presentation/widgets/profile_logout_button.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final surfaceColor = theme.cardColor;
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final cardShadow = isDark ? AppBoxes.darkCardShadow : AppBoxes.cardShadow;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(
                surfaceColor: surfaceColor,
                primaryColor: primaryColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                cardShadow: cardShadow,
              ),
              AppSpacing.gap4,
              ProfileActionList(primaryColor: primaryColor, textPrimary: textPrimary),
              AppSpacing.gap4,
              Padding(
                padding: AppSpacing.px6,
                child: Text(
                  'Settings',
                  style: AppText.bodyMedium.copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              AppSpacing.gap2,
              ProfileSettingsList(primaryColor: primaryColor, textPrimary: textPrimary),
              AppSpacing.gap4,
              ProfileLogoutButton(surfaceColor: surfaceColor, errorColor: errorColor),
              AppSpacing.gap4,
            ],
          ),
        ),
      ),
    );
  }
}
