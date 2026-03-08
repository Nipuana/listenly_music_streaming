import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/services/playbar_manager.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/common/popups/song_details_popup.dart';

class PlaybarOverlay extends StatefulWidget {
  const PlaybarOverlay({super.key});

  @override
  State<PlaybarOverlay> createState() => _PlaybarOverlayState();
}

class _PlaybarOverlayState extends State<PlaybarOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final manager = PlaybarManager.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Initialize controller based on current state
    if (manager.overlayVisible) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }

    manager.addListener(_onManagerChanged);
  }

  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) return imagePath;
    final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$baseUrl/$cleanPath';
  }

  void _onManagerChanged() {
    // Drive the controller when overlayVisible toggles
    if (manager.overlayVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    // If song/playing state changes, update UI
    setState(() {});
  }

  @override
  void dispose() {
    manager.removeListener(_onManagerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(_animation),
      child: FadeTransition(
        opacity: _animation,
        child: IgnorePointer(
          ignoring: !manager.overlayVisible && _controller.value == 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              elevation: 12,
              color: Theme.of(context).colorScheme.surface,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 84,
                  // slider overlays the top of the bar; use Stack so it doesn't push content
                  child: Stack(
                    children: [
                      // Slider positioned at the top edge
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Builder(builder: (context) {
                            final pos = manager.position;
                            final dur = manager.duration;
                            final max = dur.inMilliseconds > 0 ? dur.inMilliseconds.toDouble() : 1.0;
                            final value = dur.inMilliseconds > 0
                                ? pos.inMilliseconds.clamp(0, dur.inMilliseconds).toDouble()
                                : 0.0;
                            return SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                                trackHeight: 3,
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                                thumbColor: Theme.of(context).colorScheme.primary,
                                activeTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
                                inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                              ),
                              child: Slider(
                                min: 0,
                                max: max,
                                value: value.clamp(0.0, max),
                                onChanged: (v) {
                                  final ms = v.round();
                                  manager.seek(Duration(milliseconds: ms));
                                },
                              ),
                            );
                          }),
                        ),
                      ),

                      // Main bar content at bottom
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: SizedBox(
                            height: 56,
                            child: Row(
                              children: [
                                // Cover
                                Builder(builder: (context) {
                                  final song = manager.currentSong;
                                  return GestureDetector(
                                    onTap: () => SongDetailsPopup.show(context),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: (song?.coverImageUrl != null && song!.coverImageUrl!.isNotEmpty)
                                          ? Image.network(
                                              _getFullImageUrl(song.coverImageUrl),
                                              width: 64,
                                              height: 64,
                                              fit: BoxFit.cover,
                                              errorBuilder: (c, e, s) => Container(
                                                width: 64,
                                                height: 64,
                                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                                child: const Icon(Icons.music_note),
                                              ),
                                            )
                                          : Container(
                                              width: 64,
                                              height: 64,
                                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                              child: const Icon(Icons.music_note),
                                            ),
                                    ),
                                  );
                                }),
                                const SizedBox(width: 12),
                                // Title & artist
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        manager.currentSong?.title ?? 'No song',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        manager.currentSong?.uploadedByUsername ?? '',
                                        style: Theme.of(context).textTheme.bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                // Controls
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => manager.setShuffle(!manager.isShuffle),
                                      icon: Icon(
                                        Icons.shuffle,
                                        color: manager.isShuffle ? Theme.of(context).colorScheme.primary : null,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => manager.previous(context),
                                      icon: const Icon(Icons.skip_previous),
                                    ),
                                    IconButton(
                                      onPressed: manager.togglePlayPause,
                                      icon: Icon(manager.isPlaying ? Icons.pause : Icons.play_arrow),
                                    ),
                                    IconButton(
                                      onPressed: manager.next,
                                      icon: const Icon(Icons.skip_next),
                                    ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      onPressed: manager.toggleRepeatOne,
                                      icon: Icon(
                                        Icons.repeat_one,
                                        color: manager.isRepeatOne ? Theme.of(context).colorScheme.primary : null,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}