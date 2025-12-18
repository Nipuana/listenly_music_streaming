import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile',
        style: AppText.headline,
      ),
    );
  }
}
