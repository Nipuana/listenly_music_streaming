import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/features/auth/presentation/state/auth_state.dart';
import 'package:weplay_music_streaming/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/header/profile_header.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/actions/profile_action_list.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/settings/profile_settings_list.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/logout/profile_logout_button.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textSecondary = theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final authState = ref.watch(authViewModelProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ProfileHeader(),
                  AppSpacing.gap4,
                  const ProfileActionList(),
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
                  const ProfileSettingsList(),
                  AppSpacing.gap4,
                  const ProfileLogoutButton(),
                  AppSpacing.gap4,
                ],
              ),
            ),
          ),
        ),
        if (authState.status == AuthStatus.loading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
