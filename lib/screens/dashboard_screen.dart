import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/common/my_bottom_navigation.dart';
import 'package:weplay_music_streaming/screens/home_screen.dart';
import 'package:weplay_music_streaming/screens/library_screen.dart';
import 'package:weplay_music_streaming/screens/likes_screen.dart';
import 'package:weplay_music_streaming/screens/profile_screen.dart';
import 'package:weplay_music_streaming/screens/search_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    LibraryScreen(),
    LikesScreen(),
    ProfileScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onSearchTap() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: MyBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        onCenterTap: _onSearchTap,
      ),
      floatingActionButton: CenterFab(onPressed: _onSearchTap),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}