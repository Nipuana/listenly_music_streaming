import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home',
        style: AppText.headline,
      ),
    );
  }
}
