import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';

class LikedSongsHeaderSection extends StatelessWidget {
  final Color primaryColor;
  final int songsCount;
  final String totalDuration;

  const LikedSongsHeaderSection({
    super.key,
    required this.primaryColor,
    required this.songsCount,
    required this.totalDuration,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: ResponsiveUtils.isMobile(context) ? 280 : 320,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withValues(alpha: 0.8),
                primaryColor.withValues(alpha: 0.4),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.isMobile(context) ? 16 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppRadius.lg,
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 48),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                  // Title
                  Text(
                    'Liked Songs',
                    style: AppText.headline.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 32),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                  // Stats
                  Text(
                    '$songsCount songs • $totalDuration',
                    style: AppText.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
