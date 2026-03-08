import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/get_liked_songs_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/toggle_like_song_usecase.dart';
import 'package:weplay_music_streaming/features/user/presentation/likes/sections/liked_songs_header_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/likes/sections/liked_songs_controls_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/likes/sections/liked_songs_list_section.dart';
import 'package:weplay_music_streaming/common/my_snack.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';

class LikesScreen extends ConsumerStatefulWidget {
  const LikesScreen({super.key});

  @override
  ConsumerState<LikesScreen> createState() => _LikedSongsPageState();
}

class _LikedSongsPageState extends ConsumerState<LikesScreen> {
  List<SongEntity> _likedSongs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLikedSongs();
  }

  Future<void> _loadLikedSongs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final usecase = ref.read(getLikedSongsUsecaseProvider);
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
            _likedSongs = songs;
            _isLoading = false;
          });
        }
      },
    );
  }

  Future<void> _toggleLike(SongEntity song) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlike Song'),
        content: Text('Remove "${song.title}" from your liked songs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Unlike'),
          ),
        ],
      ),
    );

    // If user cancelled, return
    if (confirmed != true) return;

    if (!mounted) {
      return;
    }

    // Immediately remove from UI after confirmation
    setState(() {
      _likedSongs = _likedSongs.where((s) => s.id != song.id).toList();
    });

    // Show feedback message
    MySnack.show(
      context,
      message: 'Song removed from liked',
      icon: Icons.heart_broken,
    );

    // Make API call in background
    final usecase = ref.read(toggleLikeSongUsecaseProvider);
    final params = ToggleLikeParams(songId: song.id!);
    final result = await usecase(params);

    result.fold(
      (failure) {
        // If API call fails, add the song back
        if (mounted) {
          setState(() {
            _likedSongs.add(song);
          });
          MySnack.show(
            context,
            message: 'Failed to unlike: ${failure.message}',
            icon: Icons.error_outline,
            backgroundColor: Colors.red.shade900,
            textColor: Colors.white,
          );
        }
      },
      (isLiked) {
        // Success - song already removed from UI
      },
    );
  }

  String _getTotalDuration() {
    final totalSeconds = _likedSongs.fold<int>(0, (sum, song) => sum + (song.duration ?? 0));
    if (totalSeconds == 0) return '0m';
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final primaryColor = theme.colorScheme.primary;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Liked Songs'),
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Liked Songs'),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: textSecondary),
              const SizedBox(height: 16),
              Text(_error!, style: AppText.body.copyWith(color: textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadLikedSongs,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: ResponsiveUtils.centerContent(
        context,
        CustomScrollView(
          slivers: [
            // Header Section
            LikedSongsHeaderSection(
              primaryColor: primaryColor,
              songsCount: _likedSongs.length,
              totalDuration: _getTotalDuration(),
            ),

            // Controls Section
            LikedSongsControlsSection(
              likedSongs: _likedSongs,
            ),

            // Songs List Section
            LikedSongsListSection(
              likedSongs: _likedSongs,
              onUnlike: _toggleLike,
            ),
          ],
        ),
      ),
    );
  }
}
