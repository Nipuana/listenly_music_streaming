import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';
import 'package:weplay_music_streaming/features/user/data/repositories/playlist_repository_impl.dart';
import 'package:weplay_music_streaming/features/user/presentation/playlist/sections/cover_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/playlist/sections/info_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/playlist/sections/stats_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/playlist/sections/controls_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/playlist/sections/songs_header_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/playlist/sections/songs_list_section.dart';

class PlaylistDetailsPage extends ConsumerStatefulWidget {
  final String playlistId;
  final PlaylistEntity? initialPlaylist;

  const PlaylistDetailsPage({
    super.key, 
    required this.playlistId,
    this.initialPlaylist,
  });

  @override
  ConsumerState<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends ConsumerState<PlaylistDetailsPage> {
  PlaylistEntity? _playlist;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final repo = ref.read(playlistRepositoryProvider);
    final result = await repo.getPlaylistById(widget.playlistId);

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _error = failure.message;
        });
      },
      (playlist) {
        setState(() {
          _playlist = playlist;
          _isLoading = false;
        });
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

  String _formatDuration(int seconds) {
    if (seconds == 0) return '0m';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _formatSongDuration(int? seconds) {
    if (seconds == null || seconds == 0) return '--:--';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: textSecondary),
              const SizedBox(height: 16),
              Text(_error!, style: AppText.body.copyWith(color: textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPlaylist,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_playlist == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: Center(
          child: Text('Playlist not found', style: AppText.body.copyWith(color: textSecondary)),
        ),
      );
    }

    final playlist = _playlist!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          PlaylistCoverSection(
            playlist: playlist,
            getFullImageUrl: _getFullImageUrl,
          ),
          PlaylistInfoSection(playlist: playlist),
          PlaylistStatsSection(
            playlist: playlist,
            formatDuration: _formatDuration,
          ),
          PlaylistControlsSection(
            playlist: playlist,
            onPlaylistUpdated: _loadPlaylist,
            onPlaylistDeleted: () {
              Navigator.of(context).pop(true);
            },
          ),
          const PlaylistSongsHeaderSection(),
          PlaylistSongsListSection(
            playlist: playlist,
            getFullImageUrl: _getFullImageUrl,
            formatSongDuration: _formatSongDuration,
          ),
        ],
      ),
    );
  }
}
