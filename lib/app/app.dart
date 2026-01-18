import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/app/theme/app_theme.dart';
import 'package:weplay_music_streaming/features/splash/presentation/screens/flutter_splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'Lost & Found',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const FlutterSplashScreen(),
    );
}
  }
