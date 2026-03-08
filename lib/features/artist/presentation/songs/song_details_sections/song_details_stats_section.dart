import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class SongDetailsStatsSection extends StatelessWidget {
  final SongEntity song;
  final ThemeData theme;
  final bool isDark;
  final String Function(int? number) formatNumber;

  const SongDetailsStatsSection({
    super.key,
    required this.song,
    required this.theme,
    required this.isDark,
    required this.formatNumber,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'label': 'Total Plays',
        'value': formatNumber(song.playCount),
        'icon': Icons.play_circle_filled,
        'color': Colors.blue,
      },
      {
        'label': 'Total Likes',
        'value': formatNumber(song.likeCount),
        'icon': Icons.favorite,
        'color': Colors.red,
      },
      {
        'label': 'Downloads',
        'value': '0',
        'icon': Icons.download,
        'color': Colors.green,
      },
      {
        'label': 'Shares',
        'value': '0',
        'icon': Icons.share,
        'color': Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Stats',
          style: AppText.title.copyWith(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return Card(
              elevation: 0,
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
              child: Padding(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 12)),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Icon(
                            stat['icon'] as IconData,
                            color: stat['color'] as Color,
                            size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 6)),
                        Flexible(
                          child: Text(
                            stat['value'] as String,
                            style: AppText.title.copyWith(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                        Flexible(
                          child: Text(
                            stat['label'] as String,
                            style: AppText.body.copyWith(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
                              color: theme.textTheme.bodyMedium?.color,
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
              ),
            );
          },
        ),
      ],
    );
  }
}
