import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';
import 'package:weplay_music_streaming/core/providers/artist_provider.dart';
import 'package:weplay_music_streaming/common/popups/artist_details_popup.dart';

class PlaylistInfoSection extends ConsumerWidget {
  final PlaylistEntity playlist;

  const PlaylistInfoSection({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    return SliverToBoxAdapter(
      child: Padding(
        padding: AppSpacing.px4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Playlist name
            Text(
              playlist.name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            if (playlist.description != null && playlist.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  playlist.description!,
                  style: AppText.body.copyWith(color: textSecondary),
                ),
              ),

            // Creator info
            Consumer(
              builder: (context, ref, _) {
                final artistProfile = ref.watch(artistProfileProvider(playlist.createdBy));
                final creatorName = artistProfile.value?.name ?? playlist.createdByUsername ?? 'Unknown';
                
                return GestureDetector(
                  onTap: () {
                    ArtistDetailsPopup.show(context, artistName: creatorName, artistId: playlist.createdBy);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          artistProfile.when(
                            data: (profile) {
                              final initial = () {
                                final name = profile?.name ?? playlist.createdByUsername ?? 'U';
                                return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
                              }();
                              
                              if (profile?.imageUrl != null && profile!.imageUrl!.isNotEmpty) {
                                return CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(profile.imageUrl!),
                                );
                              }
                              return CircleAvatar(
                                radius: 16,
                                child: Text(initial),
                              );
                            },
                            loading: () {
                              final initial = () {
                                final name = playlist.createdByUsername ?? 'U';
                                return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
                              }();
                              return CircleAvatar(
                                radius: 16,
                                child: Text(initial),
                              );
                            },
                            error: (_, _) {
                              final initial = () {
                                final name = playlist.createdByUsername ?? 'U';
                                return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
                              }();
                              return CircleAvatar(
                                radius: 16,
                                child: Text(initial),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'By $creatorName',
                            style: AppText.bodyMedium.copyWith(color: textPrimary, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
