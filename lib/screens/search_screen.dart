import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Text(
          'Search',
          style: AppText.headline,
        ),
      ),
    );
  }
}
