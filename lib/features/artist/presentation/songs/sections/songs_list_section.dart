import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';

typedef SongTapCallback = void Function(SongEntity song);
typedef SongActionCallback = void Function(SongEntity song, String action);

class SongsListSection extends StatelessWidget {
  final List<SongEntity> songs;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;
  final Future<void> Function()? onRefresh;
  final SongTapCallback onTapSong;
  final SongActionCallback onAction;

  const SongsListSection({
    super.key,
    required this.songs,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
    this.onRefresh,
    required this.onTapSong,
    required this.onAction,
  });

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds == 0) return '--:--';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) return imagePath;
    final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$baseUrl/$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView.builder(
        padding: ResponsiveUtils.getResponsivePadding(context),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return Padding(
            padding: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            child: Card(
              elevation: 0,
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
              child: InkWell(
                onTap: () => onTapSong(song),
                borderRadius: AppRadius.lg,
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 12)),
                  child: Row(
                    children: [
                      // Cover Image
                      ClipRRect(
                        borderRadius: AppRadius.sm,
                        child: song.coverImageUrl != null && song.coverImageUrl!.isNotEmpty
                            ? Image.network(
                                _getFullImageUrl(song.coverImageUrl),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: themeColor(context).withValues(alpha: 0.15),
                                child: Icon(Icons.music_note, color: themeColor(context), size: 30),
                              ),
                      ),
                      SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),

                      // Song Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: AppText.bodyMedium.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.play_circle_outline, size: 14, color: textSecondary), SizedBox(width: 4), Text('${song.playCount}', style: AppText.body.copyWith(color: textSecondary, fontSize: 12))]),
                                Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.favorite_border, size: 14, color: textSecondary), SizedBox(width: 4), Text('${song.likeCount}', style: AppText.body.copyWith(color: textSecondary, fontSize: 12))]),
                                Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.access_time, size: 14, color: textSecondary), SizedBox(width: 4), Text(_formatDuration(song.duration), style: AppText.body.copyWith(color: textSecondary, fontSize: 12))]),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Actions Menu
                      PopupMenuButton<String>(
                        onSelected: (value) => onAction(song, value),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'stats', child: Row(children: [Icon(Icons.analytics, size: 20), SizedBox(width: 12), Text('View Stats')])),
                          const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 12), Text('Edit')])),
                          const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 20, color: Colors.red), SizedBox(width: 12), Text('Delete', style: TextStyle(color: Colors.red))])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color themeColor(BuildContext context) => Theme.of(context).colorScheme.primary;
}
