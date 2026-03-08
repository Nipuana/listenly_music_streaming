import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/common/music_flow_app_bar.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/core/services/playbar_manager.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';
import 'package:weplay_music_streaming/features/user/presentation/home/sections/welcome_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/home/sections/action_cards_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/home/sections/recently_played_header_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/home/sections/recently_played_list_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final Function(int)? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final manager = PlaybarManager.instance;

  @override
  void initState() {
    super.initState();
    manager.addListener(_onManagerUpdate);
  }

  @override
  void dispose() {
    manager.removeListener(_onManagerUpdate);
    super.dispose();
  }

  void _onManagerUpdate() {
    if (mounted) setState(() {});
  }

  void _playSong(SongEntity song) async {
    manager.setQueue([song], startIndex: 0);
    await manager.playSongAt(0);
  }

  @override
  Widget build(BuildContext context) {
    final userSessionService = ref.read(userSessionServiceProvider);
    final username = userSessionService.getCurrentUserUsername() ?? 'User';
    final recentSongs = manager.recentSongs;

    return Scaffold(
      appBar: const MusicFlowAppBar(title: 'MusicFlow'),
      body: ResponsiveUtils.centerContent(
        context,
        SingleChildScrollView(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              WelcomeSection(username: username),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),

              // Action Cards Section
              ActionCardsSection(onNavigateToTab: widget.onNavigateToTab),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 40)),

              // Recently Played Header
              RecentlyPlayedHeaderSection(hasRecentSongs: recentSongs.isNotEmpty),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

              // Recently Played List
              RecentlyPlayedListSection(
                recentSongs: recentSongs,
                manager: manager,
                onPlaySong: _playSong,
              ),
              SizedBox(height: ResponsiveUtils.getBottomPadding(context)),
            ],
          ),
        ),
      ),
    );
  }
}
