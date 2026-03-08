import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/services/playbar_manager.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';
import 'package:weplay_music_streaming/core/providers/artist_provider.dart';
import 'package:weplay_music_streaming/common/popups/song_details_popup.dart';

class PlaylistSongsListSection extends ConsumerWidget {
  final PlaylistEntity playlist;
  final String Function(String?) getFullImageUrl;
  final String Function(int?) formatSongDuration;

  const PlaylistSongsListSection({
    super.key,
    required this.playlist,
    required this.getFullImageUrl,
    required this.formatSongDuration,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final primaryColor = theme.colorScheme.primary;

    if (playlist.songs.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: AppSpacing.px4,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Icon(Icons.music_off, size: 64, color: textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(
                  'No songs in this playlist',
                  style: AppText.body.copyWith(color: textSecondary),
                ),
                const SizedBox(height: 180), // Space for bottom nav + playbar
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final song = playlist.songs[index];
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: index == playlist.songs.length - 1 ? 180 : 0,
            ),
            child: Card(
              elevation: 0,
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              child: InkWell(
                onTap: () {
                  final manager = PlaybarManager.instance;
                  manager.setQueue(playlist.songs, startIndex: index);
                  SongDetailsPopup.show(context);
                },
                borderRadius: AppRadius.sm,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Album art
                      ClipRRect(
                        borderRadius: AppRadius.sm,
                        child: song.coverImageUrl != null && song.coverImageUrl!.isNotEmpty
                            ? Image.network(
                                getFullImageUrl(song.coverImageUrl),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                color: primaryColor.withValues(alpha: 0.2),
                                child: Icon(Icons.music_note, color: primaryColor),
                              ),
                      ),
                      const SizedBox(width: 12),

                      // Song info
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
                            Consumer(
                              builder: (context, ref, _) {
                                final artistProfile = ref.watch(artistProfileBySongIdProvider(song.id));
                                return artistProfile.when(
                                  data: (profile) => Text(
                                    profile?.name ?? song.album ?? 'Unknown Artist',
                                    style: AppText.small.copyWith(color: textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  loading: () => Text(
                                    song.album ?? 'Loading...',
                                    style: AppText.small.copyWith(color: textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  error: (_, _) => Text(
                                    song.album ?? 'Unknown Artist',
                                    style: AppText.small.copyWith(color: textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Duration
                      Text(
                        formatSongDuration(song.duration),
                        style: AppText.small.copyWith(color: textSecondary),
                      ),
                      const SizedBox(width: 12),

                      // Play button
                      AnimatedBuilder(
                        animation: PlaybarManager.instance,
                        builder: (context, _) {
                          final current = PlaybarManager.instance.currentSong;
                          final isPlaying = PlaybarManager.instance.isPlaying && current?.id == song.id;
                          final isCurrentSong = current?.id == song.id;
                          
                          return IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            color: isCurrentSong ? primaryColor : textSecondary,
                            onPressed: () async {
                              final manager = PlaybarManager.instance;
                              final allowed = await manager.ensureAudioAllowed(context);
                              if (!allowed) return;

                              if (manager.currentSong?.id == song.id) {
                                manager.togglePlayPause();
                              } else {
                                manager.setQueue(playlist.songs, startIndex: index);
                                await manager.playSongAt(index);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: playlist.songs.length,
      ),
    );
  }
}
