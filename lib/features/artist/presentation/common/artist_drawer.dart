import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/features/artist/presentation/dashboard/screens/artist_dashboard_screen.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/screens/artist_songs_screen.dart';
import 'package:weplay_music_streaming/features/profile/presentation/screens/profile_screen.dart';

class ArtistNavigationPanel extends ConsumerWidget {
  final String currentRoute;
  final bool compact;

  const ArtistNavigationPanel({
    super.key,
    required this.currentRoute,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkBackground : AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(compact ? 20 : 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person_pin,
                    size: compact ? 40 : 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Artist Portal',
                    style: AppText.title.copyWith(
                      color: Colors.white,
                      fontSize: compact ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your music',
                    style: AppText.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    isSelected: currentRoute == 'dashboard',
                    onTap: () {
                      Navigator.maybePop(context);
                      if (currentRoute != 'dashboard') {
                        AppRoutes.pushReplacement(context, const ArtistDashboardScreen());
                      }
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.library_music,
                    title: 'My Songs',
                    isSelected: currentRoute == 'songs',
                    onTap: () {
                      Navigator.maybePop(context);
                      if (currentRoute != 'songs') {
                        AppRoutes.pushReplacement(context, const ArtistSongsScreen());
                      }
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person,
                    title: 'My Profile',
                    isSelected: currentRoute == 'profile',
                    onTap: () {
                      Navigator.maybePop(context);
                      if (currentRoute != 'profile') {
                        AppRoutes.push(context, const ProfileScreen());
                      }
                    },
                  ),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: theme.hintColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Artist Portal v1.0',
                      style: AppText.body.copyWith(
                        color: theme.hintColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : theme.iconTheme.color,
      ),
      title: Text(
        title,
        style: AppText.bodyMedium.copyWith(
          color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyLarge?.color,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppText.body.copyWith(
                fontSize: 12,
                color: theme.hintColor,
              ),
            )
          : null,
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
    );
  }
}

class ArtistDrawer extends ConsumerWidget {
  final String currentRoute;

  const ArtistDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ArtistNavigationPanel(currentRoute: currentRoute),
    );
  }
}
