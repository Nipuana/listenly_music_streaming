import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/common/popups/add_playlist_popup.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/sections/songs_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/sections/playlists_section.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/state/library_state.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/view_model/library_view_model.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(libraryViewModelProvider.notifier).loadSongs();
      ref.read(libraryViewModelProvider.notifier).loadPlaylists();
      ref.read(libraryViewModelProvider.notifier).loadUserPlaylistsForDropdown();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final libraryState = ref.watch(libraryViewModelProvider);
    final showClearSongFilters =
        libraryState.selectedTab == LibraryTab.songs &&
        libraryState.searchQuery.trim().isNotEmpty &&
        libraryState.selectedGenre != 'All';

    if (_searchController.text != libraryState.searchQuery) {
      _searchController.value = TextEditingValue(
        text: libraryState.searchQuery,
        selection: TextSelection.collapsed(
          offset: libraryState.searchQuery.length,
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: theme.textTheme.bodyLarge?.color,
        title: const Text('Library'),
        actions: [
          IconButton(
            onPressed: libraryState.selectedTab == LibraryTab.playlists
                ? () async {
                    final created = await AddPlaylistPopup.show(context);
                    if (!context.mounted || created != true) {
                      return;
                    }

                    await ref
                        .read(libraryViewModelProvider.notifier)
                        .refreshPlaylistCollections();
                  }
                : null,
            icon: const Icon(Icons.add),
            tooltip: 'Add playlist',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(ResponsiveUtils.isMobile(context) ? 64 : 72),
          child: Padding(
            padding: ResponsiveUtils.getResponsiveHorizontalPadding(context).add(
              const EdgeInsets.only(top: 8, bottom: 12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => ref.read(libraryViewModelProvider.notifier).setSearchQuery(v),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                ),
                suffixIcon: showClearSongFilters
                    ? TextButton(
                        onPressed: () {
                          _searchController.clear();
                          ref.read(libraryViewModelProvider.notifier).clearSongFilters();
                        },
                        child: const Text('Clear filters'),
                      )
                    : null,
                hintText: libraryState.selectedTab == LibraryTab.songs
                    ? 'Search songs'
                    : 'Search playlists',
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.isMobile(context) ? 12 : 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ResponsiveUtils.centerContent(
        context,
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab Slider
              Padding(
                padding: ResponsiveUtils.getResponsiveHorizontalPadding(context).add(
                  EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
                  ),
                ),
                child: Container(
                  height: ResponsiveUtils.isMobile(context) ? 50 : 56,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.isMobile(context) ? 25 : 28,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton(
                          context: context,
                          label: 'Songs',
                          isSelected: libraryState.selectedTab == LibraryTab.songs,
                          onTap: () {
                            ref.read(libraryViewModelProvider.notifier).changeTab(LibraryTab.songs);
                          },
                          isDark: isDark,
                        ),
                      ),
                      Expanded(
                        child: _buildTabButton(
                          context: context,
                          label: 'Playlists',
                          isSelected: libraryState.selectedTab == LibraryTab.playlists,
                          onTap: () {
                            ref.read(libraryViewModelProvider.notifier).changeTab(LibraryTab.playlists);
                          },
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),

              // Content Section
              Expanded(
                child: libraryState.selectedTab == LibraryTab.songs
                    ? SongsSection(
                        showClearFiltersAction: showClearSongFilters,
                        onClearFilters: () {
                          _searchController.clear();
                          ref.read(libraryViewModelProvider.notifier).clearSongFilters();
                        },
                      )
                    : const PlaylistsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(23),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                          color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: AppText.bodyMedium.copyWith(
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
