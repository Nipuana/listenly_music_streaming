import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/common/popups/song_details_popup.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/services/playbar_manager.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class LikedSongsListSection extends StatelessWidget {
  final List<SongEntity> likedSongs;
  final Function(SongEntity) onUnlike;

  const LikedSongsListSection({
    super.key,
    required this.likedSongs,
    required this.onUnlike,
  });

  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) return imagePath;
    final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$baseUrl/$cleanPath';
  }

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds == 0) return '--:--';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final primaryColor = theme.colorScheme.primary;

    // Empty state
    if (likedSongs.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 60)),
                Icon(
                  Icons.favorite_border,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 80),
                  color: textSecondary.withValues(alpha: 0.5),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                Text(
                  'No liked songs yet',
                  style: AppText.title.copyWith(
                    color: textPrimary,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                Text(
                  'Songs you like will appear here',
                  style: AppText.body.copyWith(
                    color: textSecondary,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveUtils.getBottomPadding(context)),
              ],
            ),
          ),
        ),
      );
    }

    // Songs list
    return SliverList(
      key: ValueKey(likedSongs.length),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final song = likedSongs[index];
          final isLast = index == likedSongs.length - 1;
          return Padding(
            key: ValueKey(song.id),
            padding: ResponsiveUtils.getResponsiveHorizontalPadding(context).add(
              EdgeInsets.only(
                bottom: isLast
                    ? ResponsiveUtils.getBottomPadding(context)
                    : ResponsiveUtils.getResponsiveSpacing(context, 8),
              ),
            ),
            child: _buildSongCard(
              context: context,
              song: song,
              index: index,
              isDark: isDark,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              primaryColor: primaryColor,
            ),
          );
        },
        childCount: likedSongs.length,
      ),
    );
  }

  Widget _buildSongCard({
    required BuildContext context,
    required SongEntity song,
    required int index,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required Color primaryColor,
  }) {
    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      child: InkWell(
        onTap: () {
          final manager = PlaybarManager.instance;
          manager.setQueue(likedSongs, startIndex: index);
          SongDetailsPopup.show(context);
        },
        borderRadius: AppRadius.sm,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Album art
              ClipRRect(
                borderRadius: AppRadius.sm,
                child: song.coverImageUrl != null && song.coverImageUrl!.isNotEmpty
                    ? Image.network(
                        _getFullImageUrl(song.coverImageUrl),
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 56,
                            height: 56,
                            color: primaryColor.withValues(alpha: 0.2),
                            child: Icon(Icons.music_note, color: primaryColor, size: 28),
                          );
                        },
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        color: primaryColor.withValues(alpha: 0.2),
                        child: Icon(Icons.music_note, color: primaryColor, size: 28),
                      ),
              ),
              const SizedBox(width: 12),

              // Song info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    Row(
                      children: [
                        if (song.uploadedByUsername != null) ...[
                          Flexible(
                            child: Text(
                              song.uploadedByUsername!,
                              style: AppText.body.copyWith(color: textSecondary, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            ' • ',
                            style: AppText.body.copyWith(color: textSecondary, fontSize: 13),
                          ),
                        ],
                        Text(
                          _formatDuration(song.duration),
                          style: AppText.body.copyWith(color: textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Unlike button
              IconButton(
                onPressed: () => onUnlike(song),
                icon: const Icon(Icons.heart_broken),
                color: Colors.red.shade400,
                iconSize: 24,
                tooltip: 'Unlike',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
