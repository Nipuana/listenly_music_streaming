import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weplay_music_streaming/common/my_snack.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/delete_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/get_artist_song_details_usecase.dart';
import 'package:weplay_music_streaming/features/artist/presentation/common/artist_shell.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/modals/edit_song_modal.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/song_details_sections/song_details_actions_section.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/song_details_sections/audio_player/song_details_audio_player_section.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/song_details_sections/song_details_cover_section.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/song_details_sections/song_details_info_section.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/song_details_sections/song_details_stats_section.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class SongDetailsScreen extends ConsumerStatefulWidget {
  final SongEntity song;

  const SongDetailsScreen({super.key, required this.song});

  @override
  ConsumerState<SongDetailsScreen> createState() => _SongDetailsScreenState();
}

class _SongDetailsScreenState extends ConsumerState<SongDetailsScreen> {
  SongEntity? _detailedSong;
  bool _isLoading = true;
  String? _error;
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isBuffering = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadSongDetails();
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    
    // Listen to player state changes
    _audioPlayer?.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _isBuffering = state.processingState == ProcessingState.buffering ||
                        state.processingState == ProcessingState.loading;
        });
      }
    });

    // Listen to duration changes
    _audioPlayer?.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() {
          _duration = duration;
        });
      }
    });

    // Listen to position changes
    _audioPlayer?.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });
    
    // Load the audio URL. Try direct setUrl first; if Android blocks cleartext
    // HTTP, download the file to a temp file and play from disk (like PlaybarManager).
    final audioUrl = _getFullImageUrl(widget.song.audioUrl);
    if (audioUrl.isNotEmpty) {
      try {
        await _audioPlayer?.setUrl(audioUrl);
      } catch (e) {
        try {
          final storage = const FlutterSecureStorage();
          final token = await storage.read(key: 'auth_token');
          final uri = Uri.parse(audioUrl);
          final client = HttpClient();
          final req = await client.getUrl(uri);
          if (token != null && token.isNotEmpty) {
            req.headers.set('Authorization', 'Bearer $token');
          }
          final resp = await req.close();
          if (resp.statusCode == 200) {
            final bytes = await consolidateHttpClientResponseBytes(resp);
            final dir = await getTemporaryDirectory();
            final file = File('${dir.path}/${uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'audio.tmp'}');
            await file.writeAsBytes(bytes, flush: true);
            await _audioPlayer?.setFilePath(file.path);
          } else {
            throw Exception('HTTP ${resp.statusCode}');
          }
          client.close(force: true);
        } catch (e2) {
          if (mounted) {
            setState(() {
              _error = 'Failed to load audio: $e2';
            });
          }
        }
      }
    }
  }
  
  Future<void> _togglePlayPause() async {
    if (_audioPlayer == null) return;
    
    if (_isPlaying) {
      await _audioPlayer!.pause();
    } else {
      await _audioPlayer!.play();
    }
  }
  
  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  
  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _loadSongDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final usecase = ref.read(getArtistSongDetailsUsecaseProvider);
    final result = await usecase(GetArtistSongDetailsParams(songId: widget.song.id ?? ''));

    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = failure.message;
            _detailedSong = widget.song; // Fallback to passed song data
          });
        }
      },
      (song) {
        if (mounted) {
          setState(() {
            _detailedSong = song;
            _isLoading = false;
          });
        }
      },
    );
  }

  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) return imagePath;
    final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$baseUrl/$cleanPath';
  }

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds == 0) return 'N/A';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  String _formatNumber(int? number) {
    if (number == null) return '0';
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }

  Future<void> _openEditModal() async {
    final song = _detailedSong ?? widget.song;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => EditSongModal(
        song: song,
        onSave: (updated) {
          setState(() {
            _detailedSong = updated;
          });
          MySnack.show(context, message: 'Song updated successfully', icon: Icons.check);
        },
      ),
    );
  }

  Future<void> _deleteSong() async {
    final song = _detailedSong ?? widget.song;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Song'),
        content: Text('Are you sure you want to delete "${song.title}"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
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
        MySnack.show(context, message: 'Song deleted successfully', icon: Icons.check);
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    final song = _detailedSong ?? widget.song;

    return ArtistShell(
      currentRoute: 'songs',
      title: song.title,
      body: CustomScrollView(
        slivers: [
          SongDetailsCoverSection(
            song: song,
            getFullImageUrl: _getFullImageUrl,
          ),

          // Content
          SliverToBoxAdapter(
            child: ResponsiveUtils.centerContent(
              context,
              Padding(
                padding: ResponsiveUtils.getResponsivePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: AppRadius.lg,
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning, color: Colors.orange),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Could not load detailed stats: $_error',
                                style: AppText.body.copyWith(color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SongDetailsInfoSection(
                      song: song,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      isDark: isDark,
                      formatDuration: _formatDuration,
                    ),

                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),

                    SongDetailsStatsSection(
                      song: song,
                      theme: theme,
                      isDark: isDark,
                      formatNumber: _formatNumber,
                    ),

                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),

                    SongDetailsAudioPlayerSection(
                      isDark: isDark,
                      isBuffering: _isBuffering,
                      isPlaying: _isPlaying,
                      position: _position,
                      duration: _duration,
                      onTogglePlayPause: () {
                        _togglePlayPause();
                      },
                      onSeek: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await _audioPlayer?.seek(position);
                      },
                      formatTime: _formatTime,
                    ),

                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),

                    SongDetailsActionsSection(
                      onEdit: _openEditModal,
                      onDelete: _deleteSong,
                    ),

                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
