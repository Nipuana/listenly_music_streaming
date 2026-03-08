import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/services/playbar_manager.dart';
import 'package:weplay_music_streaming/common/playbar/playbar_overlay.dart';
import 'package:weplay_music_streaming/features/user/presentation/home/screens/home_screen.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/screens/library_screen.dart';
import 'package:weplay_music_streaming/features/user/presentation/likes/screens/likes_screen.dart';
import 'package:weplay_music_streaming/features/profile/presentation/screens/profile_screen.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';

class MyBottomNavigation extends StatefulWidget {
  const MyBottomNavigation({super.key});

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  int _selectedIndex = 0;
  final manager = PlaybarManager.instance;

  @override
  void initState() {
    super.initState();
    manager.addListener(_onPlaybarChanged);
  }

  void _onPlaybarChanged() => setState(() {});

  @override
  void dispose() {
    manager.removeListener(_onPlaybarChanged);
    super.dispose();
  }

  void _onTab(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(onNavigateToTab: _onTab);
      case 1:
        return const LikesScreen();
      case 2:
        return Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const LibraryScreen(),
              settings: settings,
            );
          },
        );
      case 3:
        return const ProfileScreen();
      default:
        return HomeScreen(onNavigateToTab: _onTab);
    }
  }

  Future<void> _handlePopInvoked(bool didPop, Object? result) async {
    if (didPop) return;
    
    // Show exit confirmation dialog
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    
    if (shouldExit == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color activeColor = AppColors.primary;
    final Color inactiveColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final Color barColor = isDark ? AppColors.darkSurface : AppColors.surface;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handlePopInvoked,
      child: Scaffold(
        body: Stack(
          children: [
            _getCurrentScreen(),
            const PlaybarOverlay(),
          ],
        ),
      extendBody: true,
      floatingActionButton: _buildSearchButton(activeColor, barColor, isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 90,
        color: barColor,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
              index: 0,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
            ),
            _buildNavItem(
              icon: Icons.favorite_outline_rounded,
              activeIcon: Icons.favorite_rounded,
              label: 'Likes',
              index: 1,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
            ),
            const SizedBox(width: 70), // Space for FAB
            _buildNavItem(
              icon: Icons.library_music_outlined,
              activeIcon: Icons.library_music_rounded,
              label: 'Library',
              index: 2,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
            ),
            _buildNavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: 'Profile',
              index: 3,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildSearchButton(Color activeColor, Color barColor, bool isDark) {
    return Transform.translate(
      offset: const Offset(0, 5),
      child: GestureDetector(
        onTap: () => PlaybarManager.instance.toggleOverlay(),
        child: AnimatedBuilder(
          animation: manager,
          builder: (context, _) {
            final overlayVisible = manager.overlayVisible;
            final isPlaying = manager.isPlaying;
            final iconData = overlayVisible
                ? Icons.close_rounded
                  : (isPlaying ? Icons.pause_rounded : Icons.arrow_upward_rounded);

            return Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    activeColor,
                    activeColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withValues(alpha: overlayVisible ? 0.5 : 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                iconData,
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    IconData? activeIcon,
    required String label,
    required int index,
    required Color activeColor,
    required Color inactiveColor,
    required bool isDark,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? activeColor : inactiveColor;
    final displayIcon = isSelected ? (activeIcon ?? icon) : icon;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTab(index),
          splashColor: activeColor.withValues(alpha: 0.1),
          highlightColor: activeColor.withValues(alpha: 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                displayIcon,
                color: color,
                size: 30,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
