import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:weplay_music_streaming/app/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: OnboardingScreen(),
      );
}
  }
