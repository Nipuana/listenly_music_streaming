import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/screens/navigation_screens/home_screen.dart';
import 'package:weplay_music_streaming/screens/navigation_screens/library_screen.dart';
import 'package:weplay_music_streaming/screens/navigation_screens/likes_screen.dart';
import 'package:weplay_music_streaming/screens/navigation_screens/profile_screen.dart';
import 'package:weplay_music_streaming/screens/navigation_screens/search_screen.dart';
import 'package:weplay_music_streaming/widget/nav-icon.dart';
import 'package:weplay_music_streaming/constant/app_colors.dart';

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
    ProfileScreen()
  ];

  void _onTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = AppColors.primary;
    final Color inactiveColor = AppColors.textSecondary;
    final Color fabColor = AppColors.primary;
    final Color fabIconColor = AppColors.surface;
    final Color barColor = AppColors.surface;

    return Scaffold(
      body: lstBottomScreen[_selectedIndex],
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 6),
        child: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            onPressed: () => _onTab(2),
            backgroundColor: fabColor,
            foregroundColor: fabIconColor,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            child: const Icon(Icons.search, size: 36),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 9,
        color: barColor,
        elevation: 12,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NavIcon(
                icon: Icons.home,
                index: 0,
                selectedIndex: _selectedIndex,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _onTab(0),
              ),
              NavIcon(
                icon: Icons.favorite,
                index: 1,
                selectedIndex: _selectedIndex,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _onTab(1),
              ),
              const SizedBox(width: 60), 
              NavIcon(
                icon: Icons.library_music,
                index: 3,
                selectedIndex: _selectedIndex,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _onTab(3),
              ),
              NavIcon(
                icon: Icons.person,
                index: 4,
                selectedIndex: _selectedIndex,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _onTab(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}