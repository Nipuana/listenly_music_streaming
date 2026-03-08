import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class SongDetailsInfoSection extends StatelessWidget {
  final SongEntity song;
  final Color textPrimary;
  final Color textSecondary;
  final bool isDark;
  final String Function(int? seconds) formatDuration;

  const SongDetailsInfoSection({
    super.key,
    required this.song,
    required this.textPrimary,
    required this.textSecondary,
    required this.isDark,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Song Information',
          style: AppText.title.copyWith(
            color: textPrimary,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
        Card(
          elevation: 0,
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16)),
            child: Column(
              children: [
                _buildInfoRow('Artist', song.uploadedByUsername ?? 'Unknown'),
                const SizedBox(height: 12),
                _buildInfoRow('Duration', formatDuration(song.duration)),
                const SizedBox(height: 12),
                _buildInfoRow('Genre', song.genre),
                const SizedBox(height: 12),
                _buildInfoRow('Album', song.album ?? 'Single'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            label,
            style: AppText.body.copyWith(color: textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 3,
          child: Text(
            value,
            style: AppText.bodyMedium.copyWith(color: textPrimary, fontWeight: FontWeight.w600),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
