import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';

class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'My Likes',
        style: AppText.headline,
      ),
    );
  }
}
