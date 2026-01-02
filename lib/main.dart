// Starting of the project

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:weplay_music_streaming/app/app.dart';
void main() {
  //  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}