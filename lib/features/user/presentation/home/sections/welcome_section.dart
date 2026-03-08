import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';

class WelcomeSection extends StatelessWidget {
  final String username;

  const WelcomeSection({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back, $username!',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 32),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
        Text(
          'Ready to discover new music?',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
          ),
        ),
      ],
    );
  }
}
