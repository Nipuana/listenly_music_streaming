// Starting of the project
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weplay_music_streaming/app/app.dart';
import 'package:weplay_music_streaming/core/services/hive/hive_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // initialize Hive or other services if needed
  await HiveService().init();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      // overrides: [
      //   sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      // ],
      child: const MyApp(),
    ),
  );
}
