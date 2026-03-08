import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';

class PlaylistCoverSection extends StatelessWidget {
  final PlaylistEntity playlist;
  final String Function(String?) getFullImageUrl;

  const PlaylistCoverSection({
    super.key,
    required this.playlist,
    required this.getFullImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Cover image
            playlist.coverImageUrl != null && playlist.coverImageUrl!.isNotEmpty
                ? Image.network(
                    getFullImageUrl(playlist.coverImageUrl),
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: primaryColor.withValues(alpha: 0.2),
                    child: Icon(Icons.queue_music, size: 100, color: primaryColor.withValues(alpha: 0.5)),
                  ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                    theme.scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
