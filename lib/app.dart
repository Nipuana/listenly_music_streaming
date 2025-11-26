import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/screens/onboarding_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
      );
}
  }
