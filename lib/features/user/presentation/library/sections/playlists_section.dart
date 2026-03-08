import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/state/library_state.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/view_model/library_view_model.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/widgets/playlist_card.dart';

class PlaylistsSection extends ConsumerWidget {
  const PlaylistsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final libraryState = ref.watch(libraryViewModelProvider);
    final currentUserId = ref.watch(userSessionServiceProvider).getCurrentUserId();

    if (libraryState.status == LibraryStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (libraryState.status == LibraryStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            AppSpacing.gap4,
            Text(
              libraryState.errorMessage ?? 'Failed to load playlists',
              style: AppText.bodyMedium.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gap4,
            ElevatedButton(
              onPressed: () {
                ref.read(libraryViewModelProvider.notifier).loadPlaylists();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Filter playlists based on selected filter
    final allPlaylists = libraryState.playlists;
    final filteredByOwnership = switch (libraryState.playlistFilter) {
      PlaylistFilter.myPlaylists => allPlaylists
        .where((playlist) => playlist.createdBy == currentUserId)
        .toList(),
      PlaylistFilter.favoritePlaylists => allPlaylists
        .where((playlist) => playlist.isFavorited ?? false)
        .toList(),
      PlaylistFilter.allPlaylists => allPlaylists
        .where((playlist) => playlist.createdBy != currentUserId)
        .toList(),
    };

    final query = libraryState.searchQuery.trim().toLowerCase();
    final filteredPlaylists = query.isEmpty
        ? filteredByOwnership
        : filteredByOwnership.where((p) {
            final name = p.name.toLowerCase();
            final creator = (p.createdByUsername ?? '').toLowerCase();
            return name.contains(query) || creator.contains(query);
          }).toList();

    return Column(
      children: [
        // Filter Toggle
        Padding(
          padding: AppSpacing.px6.add(AppSpacing.py2),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterButton(
                    context: context,
                    label: 'My Playlists',
                    isSelected: libraryState.playlistFilter == PlaylistFilter.myPlaylists,
                    onTap: () {
                      ref.read(libraryViewModelProvider.notifier).changePlaylistFilter(PlaylistFilter.myPlaylists);
                    },
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _buildFilterButton(
                    context: context,
                    label: 'Favorites',
                    isSelected: libraryState.playlistFilter == PlaylistFilter.favoritePlaylists,
                    onTap: () {
                      ref.read(libraryViewModelProvider.notifier).changePlaylistFilter(PlaylistFilter.favoritePlaylists);
                    },
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _buildFilterButton(
                    context: context,
                    label: 'Playlists',
                    isSelected: libraryState.playlistFilter == PlaylistFilter.allPlaylists,
                    onTap: () {
                      ref.read(libraryViewModelProvider.notifier).changePlaylistFilter(PlaylistFilter.allPlaylists);
                    },
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Playlist Grid
        if (filteredPlaylists.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.queue_music_outlined,
                    size: 64,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  AppSpacing.gap4,
                  Text(
                    query.isEmpty
                        ? switch (libraryState.playlistFilter) {
                            PlaylistFilter.myPlaylists => 'No playlists created yet',
                            PlaylistFilter.favoritePlaylists => 'No favorite playlists yet',
                            PlaylistFilter.allPlaylists => 'No playlists available',
                          }
                        : 'No playlists match your search',
                    style: AppText.bodyMedium.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(libraryViewModelProvider.notifier).loadPlaylists();
              },
              child: GridView.builder(
                padding: AppSpacing.px4.add(AppSpacing.py2),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: filteredPlaylists.length,
                itemBuilder: (context, index) {
                  final playlist = filteredPlaylists[index];
                  return PlaylistCard(
                    playlist: playlist,
                    showFavoriteButton: libraryState.playlistFilter != PlaylistFilter.myPlaylists,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: AppText.bodyMedium.copyWith(
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
