import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';

class SongDetailsAudioPlayerSection extends StatelessWidget {
  final bool isDark;
  final bool isBuffering;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final VoidCallback onTogglePlayPause;
  final ValueChanged<double> onSeek;
  final String Function(Duration duration) formatTime;

  const SongDetailsAudioPlayerSection({
    super.key,
    required this.isDark,
    required this.isBuffering,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.onTogglePlayPause,
    required this.onSeek,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16)),
        child: Column(
          children: [
            Center(
              child: isBuffering
                  ? const CircularProgressIndicator()
                  : IconButton(
                      onPressed: onTogglePlayPause,
                      icon: Icon(
                        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                    ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: position.inSeconds.toDouble().clamp(0, duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0),
                    max: duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0,
                    onChanged: onSeek,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(position),
                        style: AppText.body.copyWith(
                          color: textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        formatTime(duration),
                        style: AppText.body.copyWith(
                          color: textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
