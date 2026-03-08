import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/services/playbar_manager.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class LikedSongsControlsSection extends StatelessWidget {
  final List<SongEntity> likedSongs;

  const LikedSongsControlsSection({
    super.key,
    required this.likedSongs,
  });

  @override
  Widget build(BuildContext context) {
    if (likedSongs.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SliverToBoxAdapter(
      child: Padding(
        padding: ResponsiveUtils.getResponsiveHorizontalPadding(context).add(
          EdgeInsets.symmetric(
            vertical: ResponsiveUtils.getResponsiveSpacing(context, 20),
          ),
        ),
        child: AnimatedBuilder(
          animation: PlaybarManager.instance,
          builder: (context, _) {
            final manager = PlaybarManager.instance;
            final isPlaylistPlaying = manager.currentSong != null &&
                likedSongs.any((song) => song.id == manager.currentSong?.id) &&
                manager.isPlaying;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play/Pause button
                _buildControlButton(
                  context: context,
                  theme: theme,
                  primaryColor: primaryColor,
                  icon: isPlaylistPlaying ? Icons.pause : Icons.play_arrow,
                  label: isPlaylistPlaying ? 'Pause' : 'Play All',
                  onPressed: () async {
                    final allowed = await manager.ensureAudioAllowed(context);
                    if (!allowed) return;

                    if (isPlaylistPlaying) {
                      manager.togglePlayPause();
                    } else {
                      manager.setQueue(likedSongs, startIndex: 0);
                      await manager.playSongAt(0);
                    }
                  },
                  isPrimary: true,
                ),
                const SizedBox(width: 12),

                // Shuffle button
                _buildControlButton(
                  context: context,
                  theme: theme,
                  primaryColor: primaryColor,
                  icon: manager.isShuffle ? Icons.shuffle_on_rounded : Icons.shuffle,
                  label: 'Shuffle',
                  onPressed: () async {
                    final allowed = await manager.ensureAudioAllowed(context);
                    if (!allowed) return;

                    // Shuffle the songs list
                    final shuffledSongs = List<SongEntity>.from(likedSongs)..shuffle();
                    manager.setShuffle(true);
                    manager.setQueue(shuffledSongs, startIndex: 0);
                    await manager.playSongAt(0);
                  },
                  isActive: manager.isShuffle,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required ThemeData theme,
    required Color primaryColor,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
    bool isActive = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? primaryColor
            : isActive
            ? primaryColor.withValues(alpha: 0.2)
                : theme.cardColor,
        foregroundColor: isPrimary
            ? Colors.white
            : isActive
                ? primaryColor
                : theme.textTheme.bodyLarge?.color,
        elevation: isPrimary ? 4 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
      ),
    );
  }
}
