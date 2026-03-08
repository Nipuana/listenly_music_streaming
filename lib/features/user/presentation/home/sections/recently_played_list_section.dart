import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/services/playbar_manager.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class RecentlyPlayedListSection extends StatelessWidget {
  final List<SongEntity> recentSongs;
  final PlaybarManager manager;
  final Function(SongEntity) onPlaySong;

  const RecentlyPlayedListSection({
    super.key,
    required this.recentSongs,
    required this.manager,
    required this.onPlaySong,
  });

  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) return imagePath;
    final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$baseUrl/$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (recentSongs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(
                Icons.music_note,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No recently played songs',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start playing music to see your history here',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentSongs.length,
      itemBuilder: (context, index) {
        final song = recentSongs.reversed.toList()[index]; // Reverse to show most recent first
        final isCurrentlyPlaying = manager.currentSong?.id == song.id && manager.isPlaying;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: song.coverImageUrl != null && song.coverImageUrl!.isNotEmpty
                        ? Image.network(
                            _getFullImageUrl(song.coverImageUrl),
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 56,
                              height: 56,
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                              child: const Icon(Icons.music_note, size: 28),
                            ),
                          )
                        : Container(
                            width: 56,
                            height: 56,
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            child: const Icon(Icons.music_note, size: 28),
                          ),
                  ),
                  if (isCurrentlyPlaying)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.graphic_eq,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                ],
              ),
              title: Text(
                song.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                song.uploadedByUsername ?? 'Unknown Artist',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: Icon(
                  isCurrentlyPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () {
                  if (isCurrentlyPlaying) {
                    manager.pause();
                  } else {
                    onPlaySong(song);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
