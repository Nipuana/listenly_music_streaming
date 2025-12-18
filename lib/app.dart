import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/screens/onboarding_screen.dart';
import 'package:weplay_music_streaming/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: OnboardingScreen(),
      );
}
  }
