import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';

class ArtistStatsCardsSection extends StatelessWidget {
  final int totalSongs;
  final int totalStreams;
  final String totalListenTime;

  const ArtistStatsCardsSection({
    super.key,
    required this.totalSongs,
    required this.totalStreams,
    required this.totalListenTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverPadding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 3,
          crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
          mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
          childAspectRatio: 1.3,
        ),
        delegate: SliverChildListDelegate([
          _buildStatCard(
            context: context,
            icon: Icons.library_music,
            label: 'Total Songs',
            value: totalSongs.toString(),
            color: Colors.purple,
            isDark: isDark,
          ),
          _buildStatCard(
            context: context,
            icon: Icons.play_circle_filled,
            label: 'Total Streams',
            value: _formatNumber(totalStreams),
            color: Colors.blue,
            isDark: isDark,
          ),
          _buildStatCard(
            context: context,
            icon: Icons.access_time,
            label: 'Listen Time',
            value: totalListenTime,
            color: Colors.green,
            isDark: isDark,
          ),
        ]),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 12)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 8)),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
              Flexible(
                child: Text(
                  value,
                  style: AppText.headline.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
              Flexible(
                child: Text(
                  label,
                  style: AppText.body.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
