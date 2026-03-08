import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/common/my_snack.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/view_model/library_view_model.dart';
import 'package:weplay_music_streaming/features/user/presentation/playlist/playlist_details_page.dart';

class PlaylistCard extends ConsumerWidget {
  final PlaylistEntity playlist;
  final bool showFavoriteButton;

  const PlaylistCard({
    super.key,
    required this.playlist,
    this.showFavoriteButton = true,
  });

  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';

    // If already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Remove /api/ from base URL and remove leading slash from imagePath
    final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;

    return '$baseUrl/$cleanPath';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final primaryColor = theme.colorScheme.primary;

    return Card(
      elevation: 0,
      color: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistDetailsPage(
                playlistId: playlist.id!,
                initialPlaylist: playlist,
              ),
            ),
          );

          if (result == true && context.mounted) {
            await ref.read(libraryViewModelProvider.notifier).refreshPlaylistCollections();
          }
        },
        borderRadius: AppRadius.lg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Playlist Cover Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: playlist.coverImageUrl != null && playlist.coverImageUrl!.isNotEmpty
                        ? Image.network(
                            _getFullImageUrl(playlist.coverImageUrl),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: primaryColor.withValues(alpha: 0.2),
                                child: Center(
                                  child: Icon(
                                    Icons.queue_music,
                                    color: primaryColor,
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: primaryColor.withValues(alpha: 0.2),
                            child: Center(
                              child: Icon(
                                Icons.queue_music,
                                color: primaryColor,
                                size: 48,
                              ),
                            ),
                          ),
                  ),

                  // Favorite Icon (Top Right)
                  if (showFavoriteButton)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          final wasFavorited = playlist.isFavorited ?? false;
                          ref.read(libraryViewModelProvider.notifier).toggleFavoritePlaylist(playlist.id!);
                          MySnack.show(
                            context,
                            message: wasFavorited ? 'Removed from favorites' : 'Added to favorites',
                            icon: wasFavorited ? Icons.star_outline : Icons.star,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            playlist.isFavorited ?? false ? Icons.star : Icons.star_border,
                            color: playlist.isFavorited ?? false ? Colors.amber : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Playlist Info
            Padding(
              padding: AppSpacing.px4.add(AppSpacing.py3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name,
                    style: AppText.bodyMedium.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    playlist.createdByUsername ?? 'My Playlist',
                    style: AppText.small.copyWith(
                      color: textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 14,
                        color: textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${playlist.songCount} songs',
                        style: AppText.small.copyWith(
                          color: textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      if (playlist.favoriteCount > 0) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${playlist.favoriteCount}',
                          style: AppText.small.copyWith(
                            color: textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
