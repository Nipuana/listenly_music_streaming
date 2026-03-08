import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/features/artist/domain/entities/artist_stats_entity.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/get_artist_dashboard_stats_usecase.dart';
import 'package:weplay_music_streaming/features/auth/presentation/state/auth_state.dart';
import 'package:weplay_music_streaming/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:weplay_music_streaming/features/artist_verification/presentation/screens/artist_verification_screen.dart';
import 'package:weplay_music_streaming/features/profile/presentation/popups/change_password_popup.dart';
import 'package:weplay_music_streaming/features/profile/presentation/popups/edit_profile_popup.dart';
import 'package:weplay_music_streaming/features/profile/presentation/screens/support_faq_screen.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/header/profile_header.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/actions/widgets/profile_action_item.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/settings/profile_settings_list.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/logout/profile_logout_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  ArtistStatsEntity? _artistStats;
  bool _isLoadingArtistStats = false;
  String? _artistStatsError;

  @override
  void initState() {
    super.initState();
    if (_isArtist) {
      _loadArtistStats();
    }
  }

  bool get _isArtist {
    final userType = ref.read(userSessionServiceProvider).getUserType();
    return userType?.toLowerCase() == 'artist';
  }

  Future<void> _loadArtistStats() async {
    setState(() {
      _isLoadingArtistStats = true;
      _artistStatsError = null;
    });

    final result = await ref.read(getArtistDashboardStatsUsecaseProvider)();

    result.fold(
      (failure) {
        if (!mounted) return;
        setState(() {
          _artistStats = null;
          _artistStatsError = failure.message;
          _isLoadingArtistStats = false;
        });
      },
      (stats) {
        if (!mounted) return;
        setState(() {
          _artistStats = stats;
          _artistStatsError = null;
          _isLoadingArtistStats = false;
        });
      },
    );
  }

  void _openEditProfile() {
    EditProfilePopup.show(context);
  }

  void _openArtistVerification() {
    AppRoutes.push(context, const ArtistVerificationScreen());
  }

  void _openChangePassword() {
    ChangePasswordPopup.show(context);
  }

  void _openSupportFaq() {
    AppRoutes.push(context, const SupportFaqScreen());
  }

  List<ProfileHeaderStatData> _buildArtistStats() {
    final stats = _artistStats;
    return [
      ProfileHeaderStatData(
        count: stats?.totalSongs.toString() ?? '0',
        label: 'Uploaded Songs',
      ),
      ProfileHeaderStatData(
        count: _formatTotalHours(stats?.totalListenTimeSeconds ?? 0),
        label: 'Total Hours',
      ),
      ProfileHeaderStatData(
        count: _formatTotalStreams(stats?.totalStreams ?? 0),
        label: 'Total Streams',
      ),
    ];
  }

  String _formatTotalHours(int totalSeconds) {
    final totalHours = totalSeconds / 3600;
    if (totalHours >= 10) {
      return totalHours.toStringAsFixed(0);
    }
    return totalHours.toStringAsFixed(
      totalHours == totalHours.roundToDouble() ? 0 : 1,
    );
  }

  String _formatTotalStreams(int totalStreams) {
    if (totalStreams >= 1000000) {
      return '${(totalStreams / 1000000).toStringAsFixed(1)}M';
    }
    if (totalStreams >= 1000) {
      return '${(totalStreams / 1000).toStringAsFixed(1)}K';
    }
    return totalStreams.toString();
  }

  Widget _buildArtistMenuCard({required List<Widget> children}) {
    final theme = Theme.of(context);
    return Card(
      margin: AppSpacing.px4,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      elevation: 0,
      color: theme.cardColor,
      child: ClipRRect(
        borderRadius: AppRadius.xl,
        child: Column(children: children),
      ),
    );
  }

  List<Widget> _buildArtistProfileSections(
    ThemeData theme,
    Color textSecondary,
  ) {
    return [
      ProfileHeader(stats: _buildArtistStats()),
      AppSpacing.gap4,
      _buildArtistMenuCard(
        children: [
          ProfileActionItem(
            icon: Icons.edit,
            label: 'Edit Profile',
            onTap: _openEditProfile,
            showDivider: false,
          ),
        ],
      ),
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
      _buildArtistMenuCard(
        children: [
          ProfileActionItem(
            icon: Icons.lock_outline,
            label: 'Change Password',
            onTap: _openChangePassword,
          ),
          ProfileActionItem(
            icon: Icons.help_outline_rounded,
            label: 'Support & FAQ',
            onTap: _openSupportFaq,
            showDivider: false,
          ),
        ],
      ),
      if (_isLoadingArtistStats)
        const Padding(
          padding: AppSpacing.py4,
          child: Center(child: CircularProgressIndicator()),
        ),
      if (_artistStatsError != null)
        Padding(
          padding: AppSpacing.px4.add(AppSpacing.py2),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
            elevation: 0,
            color: theme.cardColor,
            child: Padding(
              padding: AppSpacing.px4.add(AppSpacing.py3),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.orange),
                  AppSpacing.hGap3,
                  Expanded(
                    child: Text(
                      _artistStatsError!,
                      style: AppText.small.copyWith(color: textSecondary),
                    ),
                  ),
                  TextButton(
                    onPressed: _loadArtistStats,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      AppSpacing.gap4,
      const ProfileLogoutButton(),
      AppSpacing.gap4,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final authState = ref.watch(authViewModelProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _isArtist
                    ? _buildArtistProfileSections(theme, textSecondary)
                    : [
                        const ProfileHeader(stats: []),
                        AppSpacing.gap4,
                        _buildArtistMenuCard(
                          children: [
                            ProfileActionItem(
                              icon: Icons.edit,
                              label: 'Edit Profile',
                              onTap: _openEditProfile,
                            ),
                            ProfileActionItem(
                              icon: Icons.verified_outlined,
                              label: 'Verify as Artist',
                              onTap: _openArtistVerification,
                              showDivider: false,
                            ),
                          ],
                        ),
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
                        ProfileSettingsList(
                          onChangePassword: _openChangePassword,
                          onOpenSupport: _openSupportFaq,
                        ),
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
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
