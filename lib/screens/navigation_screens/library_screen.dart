import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Library',
        style: AppText.headline,
      ),
    );
  }
}
