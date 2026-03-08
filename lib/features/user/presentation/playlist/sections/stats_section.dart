import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';

class PlaylistStatsSection extends StatelessWidget {
  final PlaylistEntity playlist;
  final String Function(int) formatDuration;

  const PlaylistStatsSection({
    super.key,
    required this.playlist,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    return SliverToBoxAdapter(
      child: Padding(
        padding: AppSpacing.px4,
        child: Row(
          children: [
            Icon(Icons.music_note, size: 16, color: textSecondary),
            const SizedBox(width: 4),
            Text('${playlist.songCount} songs', style: AppText.small.copyWith(color: textSecondary)),
            const SizedBox(width: 16),
            Icon(Icons.access_time, size: 16, color: textSecondary),
            const SizedBox(width: 4),
            Text(formatDuration(playlist.totalDuration), style: AppText.small.copyWith(color: textSecondary)),
            const SizedBox(width: 16),
            Icon(Icons.star, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            Text('${playlist.favoriteCount}', style: AppText.small.copyWith(color: textSecondary)),
          ],
        ),
      ),
    );
  }
}
