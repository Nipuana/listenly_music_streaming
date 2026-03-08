import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/state/library_state.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/view_model/library_view_model.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/widgets/song_card.dart';

class SongsSection extends ConsumerWidget {
  final bool showClearFiltersAction;
  final VoidCallback onClearFilters;

  const SongsSection({
    super.key,
    required this.showClearFiltersAction,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final libraryState = ref.watch(libraryViewModelProvider);
    final normalizedGenre = libraryState.selectedGenre.toLowerCase();

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
              libraryState.errorMessage ?? 'Failed to load songs',
              style: AppText.bodyMedium.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gap4,
            ElevatedButton(
              onPressed: () {
                ref.read(libraryViewModelProvider.notifier).loadSongs();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final availableGenres = <String>{'All'}
      ..addAll(
        libraryState.songs
            .map((song) => song.genre.trim())
            .where((genre) => genre.isNotEmpty)
            .map(_formatGenreLabel),
      );

    final query = libraryState.searchQuery.trim().toLowerCase();
    final filteredSongs = libraryState.songs.where((song) {
      final title = song.title.toLowerCase();
      final artist = (song.uploadedByUsername ?? '').toLowerCase();
      final songGenre = song.genre.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty || title.contains(query) || artist.contains(query);
      final matchesGenre =
          normalizedGenre == 'all' || songGenre == normalizedGenre;
      return matchesQuery && matchesGenre;
    }).toList();

    if (filteredSongs.isEmpty) {
      return Column(
        children: [
          _GenreFilterRow(
            genres: availableGenres.toList()..sort(),
            selectedGenre: libraryState.selectedGenre,
            showClearFiltersAction: showClearFiltersAction,
            onGenreSelected: (genre) {
              ref.read(libraryViewModelProvider.notifier).changeSongGenre(genre);
            },
            onClearFilters: onClearFilters,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note_outlined,
                    size: 64,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  AppSpacing.gap4,
                  Text(
                    query.isEmpty && normalizedGenre == 'all'
                        ? 'No songs yet'
                        : 'No songs match your filters',
                    style: AppText.bodyMedium.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _GenreFilterRow(
          genres: availableGenres.toList()..sort(),
          selectedGenre: libraryState.selectedGenre,
          showClearFiltersAction: showClearFiltersAction,
          onGenreSelected: (genre) {
            ref.read(libraryViewModelProvider.notifier).changeSongGenre(genre);
          },
          onClearFilters: onClearFilters,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(libraryViewModelProvider.notifier).loadSongs();
            },
            child: ListView.builder(
              padding: ResponsiveUtils.getResponsiveHorizontalPadding(context).add(
                EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveSpacing(context, 8)),
              ),
              itemCount: filteredSongs.length + 1,
              itemBuilder: (context, index) {
                if (index == filteredSongs.length) {
                  return SizedBox(height: ResponsiveUtils.getBottomPadding(context));
                }
                final song = filteredSongs[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: ResponsiveUtils.getResponsiveSpacing(context, 12),
                  ),
                  child: SongCard(
                    song: song,
                    userPlaylists: libraryState.userPlaylists,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _formatGenreLabel(String genre) {
    if (genre.isEmpty) {
      return 'Unknown';
    }

    return genre
        .split(RegExp(r'[-_\s]+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

class _GenreFilterRow extends StatelessWidget {
  final List<String> genres;
  final String selectedGenre;
  final bool showClearFiltersAction;
  final ValueChanged<String> onGenreSelected;
  final VoidCallback onClearFilters;

  const _GenreFilterRow({
    required this.genres,
    required this.selectedGenre,
    required this.showClearFiltersAction,
    required this.onGenreSelected,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (showClearFiltersAction)
          Padding(
            padding: ResponsiveUtils.getResponsiveHorizontalPadding(context).add(
              const EdgeInsets.only(top: 4),
            ),
            child: Row(
              children: [
                Text(
                  'Genre',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.filter_alt_off, size: 18),
                  label: const Text('Clear filters'),
                ),
              ],
            ),
          ),
        SizedBox(
          height: 52,
          child: ListView.separated(
            padding: ResponsiveUtils.getResponsiveHorizontalPadding(context).add(
              EdgeInsets.only(top: showClearFiltersAction ? 0 : 4, bottom: 4),
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final genre = genres[index];
              final isSelected = genre == selectedGenre;

              return FilterChip(
                label: Text(genre),
                selected: isSelected,
                onSelected: (_) => onGenreSelected(genre),
                showCheckmark: false,
                selectedColor: theme.colorScheme.primary.withValues(alpha: 0.16),
                labelStyle: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.35)
                      : theme.dividerColor.withValues(alpha: 0.2),
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemCount: genres.length,
          ),
        ),
      ],
    );
  }
}
