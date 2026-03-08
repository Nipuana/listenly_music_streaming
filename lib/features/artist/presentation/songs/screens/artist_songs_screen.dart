import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/common/my_snack.dart';
// removed unused ApiEndpoints import
// unused app color/radius imports removed
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/delete_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/get_artist_songs_usecase.dart';
import 'package:weplay_music_streaming/features/artist/presentation/common/artist_shell.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/screens/song_details_screen.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/sections/add_modal/add_song_modal.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/sections/songs_list_section.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/modals/edit_song_modal.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class ArtistSongsScreen extends ConsumerStatefulWidget {
  const ArtistSongsScreen({super.key});

  @override
  ConsumerState<ArtistSongsScreen> createState() => _ArtistSongsScreenState();
}

class _ArtistSongsScreenState extends ConsumerState<ArtistSongsScreen> {
  List<SongEntity> _songs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final usecase = ref.read(getArtistSongsUsecaseProvider);
    final result = await usecase();

    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = failure.message;
          });
        }
      },
      (songs) {
        if (mounted) {
          setState(() {
            _songs = songs;
            _isLoading = false;
          });
        }
      },
    );
  }

  // Removed unused helpers: _getFullImageUrl and _formatDuration

  Future<void> _deleteSong(SongEntity song) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Song'),
        content: Text('Are you sure you want to delete "${song.title}"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed != true) return;

    final usecase = ref.read(deleteArtistSongUsecaseProvider);
    final result = await usecase(DeleteArtistSongParams(songId: song.id ?? ''));

    if (!mounted) return;

    result.fold(
      (failure) {
        MySnack.show(context, message: failure.message, icon: Icons.error_outline);
      },
      (_) {
        setState(() {
          _songs.removeWhere((item) => item.id == song.id);
        });
        MySnack.show(context, message: 'Song deleted successfully', icon: Icons.check);
      },
    );
  }

  Future<void> _openSongDetails(SongEntity song) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SongDetailsScreen(song: song)),
    );

    if (!mounted) return;
    _loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    if (_isLoading) {
      return const ArtistShell(
        currentRoute: 'songs',
        title: 'My Songs',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return ArtistShell(
        currentRoute: 'songs',
        title: 'My Songs',
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.error_outline, size: 64, color: textSecondary),
            const SizedBox(height: 16),
            Text(_error!, style: AppText.body.copyWith(color: textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadSongs, child: const Text('Retry')),
          ]),
        ),
      );
    }

    return ArtistShell(
      currentRoute: 'songs',
      title: 'My Songs',
      actions: [
        IconButton(onPressed: _loadSongs, icon: const Icon(Icons.refresh), tooltip: 'Refresh'),
      ],
      body: ResponsiveUtils.centerContent(
        context,
        _songs.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note, size: 80, color: textSecondary.withValues(alpha: 0.5)),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    Text('No songs yet', style: AppText.title.copyWith(color: textPrimary, fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20))),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                    Text('Upload your first song to get started', style: AppText.body.copyWith(color: textSecondary, fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14)), textAlign: TextAlign.center),
                  ],
                ),
              )
            : SongsListSection(
                songs: _songs,
                isDark: isDark,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                onRefresh: _loadSongs,
                onTapSong: _openSongDetails,
                onAction: (song, action) {
                  switch (action) {
                    case 'stats':
                      _openSongDetails(song);
                      break;
                    case 'edit':
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => EditSongModal(
                          song: song,
                          onSave: (updated) {
                            setState(() {
                              final idx = _songs.indexWhere((s) => s.id == updated.id);
                              if (idx != -1) _songs[idx] = updated;
                            });
                            MySnack.show(context, message: 'Song updated successfully', icon: Icons.check);
                          },
                        ),
                      );
                      break;
                    case 'delete':
                      _deleteSong(song);
                      break;
                    default:
                  }
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => AddSongModal(
              onCreated: (song) {
                setState(() {
                  _songs = [song, ..._songs];
                });
                MySnack.show(context, message: 'Song uploaded successfully', icon: Icons.check);
              },
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Upload Song'),
      ),
    );
  }
}
  
