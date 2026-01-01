import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/common/music_flow_app_bar.dart';
import 'package:weplay_music_streaming/core/constants/app_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MusicFlowAppBar(title: 'MusicFlow'),
      body: Center(
        child: Text(
          'Home',
          style: AppText.headline,
        ),
      ),
    );
  }
}
