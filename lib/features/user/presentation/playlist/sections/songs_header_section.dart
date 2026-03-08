import 'package:flutter/material.dart';

class PlaylistSongsHeaderSection extends StatelessWidget {
  const PlaylistSongsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Text(
          'Songs',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: textPrimary),
        ),
      ),
    );
  }
}
