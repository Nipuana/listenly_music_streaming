import 'package:flutter/material.dart';

class RecentlyPlayedHeaderSection extends StatelessWidget {
  final bool hasRecentSongs;

  const RecentlyPlayedHeaderSection({
    super.key,
    required this.hasRecentSongs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recently Played',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
