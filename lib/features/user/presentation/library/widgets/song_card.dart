import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/view_model/library_view_model.dart';
import 'package:weplay_music_streaming/core/services/playbar_manager.dart';
import 'package:weplay_music_streaming/common/popups/song_details_popup.dart';
import 'package:weplay_music_streaming/common/my_snack.dart';

class SongCard extends ConsumerWidget {
  final SongEntity song;
  final List<PlaylistEntity> userPlaylists;

  const SongCard({
    super.key,
    required this.song,
    required this.userPlaylists,
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

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds == 0) return '--:--';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
        onTap: () {
          final manager = PlaybarManager.instance;
          final libState = ref.read(libraryViewModelProvider);
          final libSongs = libState.songs;
          
          // Set the song in the queue so popup shows correct song
          if (libSongs.isNotEmpty) {
            final idx = libSongs.indexWhere((s) => s.id == song.id);
            if (idx != -1) {
              manager.setQueue(libSongs, startIndex: idx);
            }
          }
          
          SongDetailsPopup.show(context);
        },
        borderRadius: AppRadius.lg,
        child: Padding(
          padding: AppSpacing.px4.add(AppSpacing.py3),
          child: Row(
            children: [
              // Album Art
              ClipRRect(
                borderRadius: AppRadius.lg,
                child: song.coverImageUrl != null && song.coverImageUrl!.isNotEmpty
                    ? Image.network(
                        _getFullImageUrl(song.coverImageUrl),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: primaryColor.withValues(alpha: 0.2),
                            child: Icon(
                              Icons.music_note,
                              color: primaryColor,
                              size: 30,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: primaryColor.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.music_note,
                          color: primaryColor,
                          size: 30,
                        ),
                      ),
              ),
              const SizedBox(width: 12),

              // Song Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: AppText.bodyMedium.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.uploadedByUsername ?? song.album ?? 'Unknown Artist',
                      style: AppText.small.copyWith(
                        color: textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _formatDuration(song.duration),
                            style: AppText.small.copyWith(
                              color: textSecondary,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.play_arrow,
                          size: 14,
                          color: textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${song.playCount}',
                            style: AppText.small.copyWith(
                              color: textSecondary,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Like button
              // Play/Pause button
              AnimatedBuilder(
                animation: PlaybarManager.instance,
                builder: (context, _) {
                  final manager = PlaybarManager.instance;
                  final current = manager.currentSong;
                  final isCurrentSong = current?.id == song.id;
                  final isPlaying = manager.isPlaying && isCurrentSong;
                  
                  return IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    color: isCurrentSong ? primaryColor : textSecondary,
                    onPressed: () async {
                      final allowed = await manager.ensureAudioAllowed(context);
                      if (!allowed) return;

                      if (isCurrentSong) {
                        manager.togglePlayPause();
                      } else {
                        // Try to enqueue the full library so next/previous work
                        final libState = ref.read(libraryViewModelProvider);
                        final libSongs = libState.songs;
                        if (libSongs.isNotEmpty) {
                          final idx = libSongs.indexWhere((s) => s.id == song.id);
                          if (idx != -1) {
                            manager.setQueue(libSongs, startIndex: idx);
                            await manager.playSongAt(idx);
                          } else {
                            manager.setQueue([song], startIndex: 0);
                            await manager.playSongAt(0);
                          }
                        } else {
                          manager.setQueue([song], startIndex: 0);
                          await manager.playSongAt(0);
                        }
                      }
                    },
                  );
                },
              ),

              IconButton(
                icon: Icon(
                  song.isLiked ?? false ? Icons.favorite : Icons.favorite_border,
                  color: song.isLiked ?? false ? Colors.red : textSecondary,
                ),
                onPressed: () {
                  final wasLiked = song.isLiked ?? false;
                  ref.read(libraryViewModelProvider.notifier).toggleLikeSong(song.id!);
                  MySnack.show(
                    context,
                    message: wasLiked ? 'Removed from liked songs' : 'Added to liked songs',
                    icon: wasLiked ? Icons.heart_broken : Icons.favorite,
                  );
                },
              ),

              // Add to playlist button -> shows user's playlists
              if (userPlaylists.isNotEmpty)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.playlist_add,
                    color: textSecondary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lg,
                  ),
                  color: surfaceColor,
                  onSelected: (value) {
                    final playlistId = value;
                    final playlistName = userPlaylists.firstWhere((p) => p.id == playlistId).name;
                    ref.read(libraryViewModelProvider.notifier).addSongToPlaylist(song.id!, playlistId);
                    MySnack.show(
                      context,
                      message: 'Added to $playlistName',
                      icon: Icons.playlist_add_check,
                    );
                  },
                  itemBuilder: (context) {
                    return userPlaylists.map((playlist) {
                      return PopupMenuItem<String>(
                        value: playlist.id!,
                        child: Row(
                          children: [
                            Icon(
                              Icons.playlist_play,
                              color: primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                playlist.name,
                                style: AppText.bodyMedium.copyWith(color: textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                )
              else
                Tooltip(
                  message: 'You have no playlists',
                  child: Icon(
                    Icons.playlist_add_outlined,
                    color: textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
