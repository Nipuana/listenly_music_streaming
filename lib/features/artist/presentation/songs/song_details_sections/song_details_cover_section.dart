import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class SongDetailsCoverSection extends StatelessWidget {
  final SongEntity song;
  final String Function(String? path) getFullImageUrl;

  const SongDetailsCoverSection({
    super.key,
    required this.song,
    required this.getFullImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          song.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            song.coverImageUrl != null && song.coverImageUrl!.isNotEmpty
                ? Image.network(
                    getFullImageUrl(song.coverImageUrl),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _fallback(theme);
                    },
                  )
                : _fallback(theme),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primary.withValues(alpha: 0.2),
      child: Icon(
        Icons.music_note,
        size: 100,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
