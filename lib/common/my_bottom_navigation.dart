import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/features/home/presentation/screens/home_screen.dart';
import 'package:weplay_music_streaming/features/library/presentation/screens/library_screen.dart';
import 'package:weplay_music_streaming/features/likes/presentation/screens/likes_screen.dart';
import 'package:weplay_music_streaming/features/profile/presentation/screens/profile_screen.dart';
import 'package:weplay_music_streaming/features/search/presentation/screens/search_screen.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';

class MyBottomNavigation extends StatefulWidget {
  const MyBottomNavigation({super.key});

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> lstBottomScreen = const [
    HomeScreen(),
    LikesScreen(),
    SearchScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  void _onTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color activeColor = AppColors.primary;
    final Color inactiveColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final Color barColor = isDark ? AppColors.darkSurface : AppColors.surface;

    return Scaffold(
      body: lstBottomScreen[_selectedIndex],
      extendBody: true,
      floatingActionButton: _buildSearchButton(activeColor, barColor, isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 90,
        color: barColor,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
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
              index: 3,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
            ),
            _buildNavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: 'Profile',
              index: 4,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton(Color activeColor, Color barColor, bool isDark) {
    final isSelected = _selectedIndex == 2;

    return Transform.translate(
      offset: const Offset(0, 20),
      child: GestureDetector(
        onTap: () => _onTab(2),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                activeColor,
                activeColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: activeColor.withOpacity(isSelected ? 0.5 : 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            size: 32,
          ),
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
          splashColor: activeColor.withOpacity(0.1),
          highlightColor: activeColor.withOpacity(0.05),
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
