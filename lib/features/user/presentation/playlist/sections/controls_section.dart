import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/services/playbar_manager.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/add_song_to_playlist_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/delete_playlist_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/get_all_songs_usecase.dart';
import 'package:weplay_music_streaming/core/utils/mysnack_utils.dart';

class PlaylistControlsSection extends ConsumerWidget {
  final PlaylistEntity playlist;
  final Future<void> Function() onPlaylistUpdated;
  final VoidCallback onPlaylistDeleted;

  const PlaylistControlsSection({
    super.key,
    required this.playlist,
    required this.onPlaylistUpdated,
    required this.onPlaylistDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: AnimatedBuilder(
          animation: PlaybarManager.instance,
          builder: (context, _) {
            final manager = PlaybarManager.instance;
            final currentUserId = ref.watch(userSessionServiceProvider).getCurrentUserId();
            final isOwner = currentUserId != null && currentUserId == playlist.createdBy;
            final hasSongs = playlist.songs.isNotEmpty;
            
            // Check if any song from this playlist is currently playing
            final isPlaylistPlaying = manager.currentSong != null &&
                playlist.songs.any((song) => song.id == manager.currentSong?.id) &&
                manager.isPlaying;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play/Pause button (only show if there are songs)
                if (hasSongs) ...[
                  _buildControlButton(
                    context: context,
                    icon: isPlaylistPlaying ? Icons.pause : Icons.play_arrow,
                    label: isPlaylistPlaying ? 'Pause' : 'Play',
                    onPressed: () async {
                      final allowed = await manager.ensureAudioAllowed(context);
                      if (!allowed) return;
                      
                      if (isPlaylistPlaying) {
                        manager.togglePlayPause();
                      } else {
                        manager.setQueue(playlist.songs, startIndex: 0);
                        await manager.playSongAt(0);
                      }
                    },
                    isPrimary: true,
                  ),
                  const SizedBox(width: 12),
                ],
                
                // Shuffle button (only show if there are songs)
                if (hasSongs) ...[
                  _buildControlButton(
                    context: context,
                    icon: manager.isShuffle ? Icons.shuffle_on_rounded : Icons.shuffle,
                    label: 'Shuffle',
                    onPressed: () {
                      manager.setShuffle(!manager.isShuffle);
                    },
                    isActive: manager.isShuffle,
                  ),
                  const SizedBox(width: 12),
                ],
                
                // Repeat button (only show if there are songs)
                if (hasSongs) ...[
                  _buildControlButton(
                    context: context,
                    icon: manager.isRepeatOne ? Icons.repeat_one_on_rounded : Icons.repeat,
                    label: 'Repeat',
                    onPressed: () {
                      manager.toggleRepeatOne();
                    },
                    isActive: manager.isRepeatOne,
                  ),
                  const SizedBox(width: 12),
                ],
                
                // Add songs button (show for owners regardless of song count)
                if (isOwner) ...[
                  _buildControlButton(
                    context: context,
                    icon: Icons.add,
                    label: 'Add',
                    onPressed: () async {
                      await _showAddSongsSheet(context, ref);
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildControlButton(
                    context: context,
                    icon: Icons.delete_outline,
                    label: 'Delete',
                    onPressed: () async {
                      await _confirmDeletePlaylist(context, ref);
                    },
                    accentColor: Theme.of(context).colorScheme.error,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
    bool isActive = false,
    Color? accentColor,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final effectiveAccentColor = accentColor ?? primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: isPrimary
              ? primaryColor
              : isActive
                  ? effectiveAccentColor.withValues(alpha: 0.2)
                  : (isDark ? AppColors.darkSurface : AppColors.surface),
          shape: CircleBorder(
            side: BorderSide(
              color: isActive ? effectiveAccentColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(14),
              child: Icon(
                icon,
                color: isPrimary
                    ? Colors.white
                    : isActive
                        ? effectiveAccentColor
                        : accentColor ?? (isDark ? Colors.white70 : Colors.black87),
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppText.small.copyWith(
            color: isPrimary || isActive
                ? effectiveAccentColor
                : accentColor ?? (isDark ? Colors.white70 : Colors.black54),
            fontWeight: isActive || isPrimary ? FontWeight.w600 : FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Future<void> _showAddSongsSheet(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(getAllSongsUsecaseProvider)();

    if (!context.mounted) {
      return;
    }

    await result.fold(
      (failure) async {
        MysnackUtils.showError(context, failure.message);
      },
      (songs) async {
        final existingSongIds = playlist.songs
            .map((song) => song.id)
            .whereType<String>()
            .toSet();
        final availableSongs = songs
            .where((song) => song.id != null && !existingSongIds.contains(song.id))
            .toList()
          ..sort((left, right) => left.title.toLowerCase().compareTo(right.title.toLowerCase()));

        if (availableSongs.isEmpty) {
          MysnackUtils.showInfo(context, 'No more songs available to add');
          return;
        }

        final selectedSong = await showModalBottomSheet<SongEntity>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (sheetContext) {
            var filteredSongs = List<SongEntity>.from(availableSongs);

            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.72,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Songs',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select a song to add to ${playlist.name}.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search songs',
                            ),
                            onChanged: (value) {
                              final query = value.trim().toLowerCase();
                              setModalState(() {
                                filteredSongs = availableSongs.where((song) {
                                  final title = song.title.toLowerCase();
                                  final artist = (song.uploadedByUsername ?? '').toLowerCase();
                                  return query.isEmpty ||
                                      title.contains(query) ||
                                      artist.contains(query);
                                }).toList();
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: filteredSongs.isEmpty
                                ? const Center(child: Text('No songs match your search'))
                                : ListView.separated(
                                    itemCount: filteredSongs.length,
                                    separatorBuilder: (_, _) => const Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final song = filteredSongs[index];
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(song.title),
                                        subtitle: Text(song.uploadedByUsername ?? song.album ?? 'Unknown Artist'),
                                        trailing: const Icon(Icons.add_circle_outline),
                                        onTap: () {
                                          Navigator.of(sheetContext).pop(song);
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );

        if (!context.mounted || selectedSong == null || selectedSong.id == null) {
          return;
        }

        final addResult = await ref.read(addSongToPlaylistUsecaseProvider)(
          AddSongToPlaylistParams(
            playlistId: playlist.id!,
            songId: selectedSong.id!,
          ),
        );

        if (!context.mounted) {
          return;
        }

        await addResult.fold(
          (failure) async {
            MysnackUtils.showError(context, failure.message);
          },
          (_) async {
            await onPlaylistUpdated();
            if (!context.mounted) {
              return;
            }
            MysnackUtils.showSuccess(context, 'Added ${selectedSong.title} to ${playlist.name}');
          },
        );
      },
    );
  }

  Future<void> _confirmDeletePlaylist(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Delete ${playlist.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final result = await ref.read(deletePlaylistUsecaseProvider)(playlist.id!);

    if (!context.mounted) {
      return;
    }

    result.fold(
      (failure) {
        MysnackUtils.showError(context, failure.message);
      },
      (_) {
        MysnackUtils.showSuccess(context, 'Playlist deleted');
        onPlaylistDeleted();
      },
    );
  }
}
