import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/services/playbar_manager.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/common/popups/artist_details_popup.dart';
import 'package:weplay_music_streaming/core/providers/artist_provider.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class SongDetailsPopup extends ConsumerStatefulWidget {
  const SongDetailsPopup._();

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const SongDetailsPopup._(),
    );
  }

  @override
  ConsumerState<SongDetailsPopup> createState() => _SongDetailsPopupState();
}

class _SongDetailsPopupState extends ConsumerState<SongDetailsPopup> {
  final manager = PlaybarManager.instance;

  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) return imagePath;
    final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$baseUrl/$cleanPath';
  }

  @override
  void initState() {
    super.initState();
    manager.addListener(_onMgr);
  }

  void _onMgr() => setState(() {});

  @override
  void dispose() {
    manager.removeListener(_onMgr);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = manager.currentSong;
    // Use a scrollable layout so the sheet won't overflow on small devices
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // drag handle
              const SizedBox(height: 6),
              Center(
                child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(4))),
              ),
              const SizedBox(height: 12),
              // content
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: (song?.coverImageUrl != null && song!.coverImageUrl!.isNotEmpty)
                          ? Image.network(_getFullImageUrl(song.coverImageUrl), width: 160, height: 160, fit: BoxFit.cover)
                        : Container(width: 160, height: 160, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12), child: const Icon(Icons.music_note, size: 64)),
                    ),
                    const SizedBox(height: 12),
                    Text(song?.title ?? 'No song', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    // Artist card with avatar and name
                    const SizedBox(height: 6),
                    Consumer(
                      builder: (context, ref, _) {
                        final artistProfile = ref.watch(artistProfileBySongIdProvider(song?.id));
                        final artistName = artistProfile.value?.name ?? song?.uploadedByUsername ?? 'Unknown Artist';
                        final artistId = artistProfile.value?.id ?? song?.uploadedBy;
                        
                        return GestureDetector(
                          onTap: () {
                            ArtistDetailsPopup.show(context, artistName: artistName, artistId: artistId);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  artistProfile.when(
                                    data: (profile) {
                                      final initial = () {
                                        final name = profile?.name ?? song?.uploadedByUsername ?? 'U';
                                        return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
                                      }();
                                      
                                      if (profile?.imageUrl != null && profile!.imageUrl!.isNotEmpty) {
                                        return CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(profile.imageUrl!),
                                        );
                                      }
                                      return CircleAvatar(
                                        radius: 20,
                                        child: Text(initial),
                                      );
                                    },
                                    loading: () {
                                      final initial = () {
                                        final name = song?.uploadedByUsername ?? 'U';
                                        return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
                                      }();
                                      return CircleAvatar(
                                        radius: 20,
                                        child: Text(initial),
                                      );
                                    },
                                    error: (_, _) {
                                      final initial = () {
                                        final name = song?.uploadedByUsername ?? 'U';
                                        return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
                                      }();
                                      return CircleAvatar(
                                        radius: 20,
                                        child: Text(initial),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        artistProfile.when(
                                          data: (profile) => Text(
                                            profile?.name ?? song?.uploadedByUsername ?? 'Unknown Artist',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                                          ),
                                          loading: () => Text(
                                            song?.uploadedByUsername ?? 'Loading...',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                                          ),
                                          error: (_, _) => Text(
                                            song?.uploadedByUsername ?? 'Unknown Artist',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text('Artist', style: Theme.of(context).textTheme.bodySmall),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              // description area
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Description', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 6),
                    Text(
                      _buildDescription(song),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
              const SizedBox(height: 18),

              // player controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 40,
                    icon: Icon(manager.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                    onPressed: () => manager.togglePlayPause(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Slider(
                      min: 0,
                      max: manager.duration.inMilliseconds > 0 ? manager.duration.inMilliseconds.toDouble() : 1.0,
                      value: manager.duration.inMilliseconds > 0 ? manager.position.inMilliseconds.clamp(0, manager.duration.inMilliseconds).toDouble() : 0.0,
                      onChanged: (v) => manager.seek(Duration(milliseconds: v.round())),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(manager.position)),
                        Text(_formatDuration(manager.duration)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  String _buildDescription(SongEntity? song) {
    if (song == null) return 'No description available.';
    final parts = <String>[];
    if ((song.album ?? '').isNotEmpty) parts.add('Album: ${song.album}');
    if (song.genre.isNotEmpty) parts.add('Genre: ${song.genre}');
    if ((song.uploadedByUsername ?? '').isNotEmpty) parts.add('By: ${song.uploadedByUsername}');
    if (parts.isEmpty) return 'No description available.';
    return parts.join(' • ');
  }

  String _formatDuration(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}
