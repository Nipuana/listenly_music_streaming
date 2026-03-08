import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/artist/domain/entities/artist_stats_entity.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/get_artist_dashboard_stats_usecase.dart';
import 'package:weplay_music_streaming/features/artist/presentation/common/artist_shell.dart';
import 'package:weplay_music_streaming/features/artist/presentation/dashboard/sections/artist_stats_cards_section.dart';
import 'package:weplay_music_streaming/features/artist/presentation/songs/screens/artist_songs_screen.dart';

class ArtistDashboardScreen extends ConsumerStatefulWidget {
  const ArtistDashboardScreen({super.key});

  @override
  ConsumerState<ArtistDashboardScreen> createState() => _ArtistDashboardScreenState();
}

class _ArtistDashboardScreenState extends ConsumerState<ArtistDashboardScreen> {
  ArtistStatsEntity? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboardStats();
  }

  Future<void> _loadDashboardStats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final usecase = ref.read(getArtistDashboardStatsUsecaseProvider);
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
      (stats) {
        if (mounted) {
          setState(() {
            _stats = stats;
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    if (_isLoading) {
      return const ArtistShell(
        currentRoute: 'dashboard',
        title: 'Dashboard',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return ArtistShell(
        currentRoute: 'dashboard',
        title: 'Dashboard',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: textSecondary),
              const SizedBox(height: 16),
              Text(_error!, style: AppText.body.copyWith(color: textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDashboardStats,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_stats == null) {
      return ArtistShell(
        currentRoute: 'dashboard',
        title: 'Dashboard',
        body: Center(
          child: Text(
            'No stats available',
            style: AppText.body.copyWith(color: textSecondary),
          ),
        ),
      );
    }

    return ArtistShell(
      currentRoute: 'dashboard',
      title: 'Dashboard',
      body: ResponsiveUtils.centerContent(
        context,
        RefreshIndicator(
          onRefresh: _loadDashboardStats,
          child: CustomScrollView(
            slivers: [
              // Welcome Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
                    top: ResponsiveUtils.isDesktop(context)
                        ? 8
                        : ResponsiveUtils.getResponsiveSpacing(context, 16),
                    bottom: ResponsiveUtils.getResponsiveSpacing(context, 24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: AppText.headline.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                      Text(
                        'Here\'s your music performance overview',
                        style: AppText.body.copyWith(
                          color: textSecondary,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Stats Cards
              ArtistStatsCardsSection(
                totalSongs: _stats!.totalSongs,
                totalStreams: _stats!.totalStreams,
                totalListenTime: _stats!.totalListenTime,
              ),

              // Manage Songs Button
              SliverToBoxAdapter(
                child: Padding(
                  padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
                    top: ResponsiveUtils.getResponsiveSpacing(context, 32),
                    bottom: ResponsiveUtils.getBottomPadding(context),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AppRoutes.push(context, const ArtistSongsScreen());
                    },
                    icon: const Icon(Icons.music_note),
                    label: const Text('Manage My Songs'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
                      ),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
