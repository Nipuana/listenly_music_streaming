import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_colors.dart';
import 'package:weplay_music_streaming/constant/app_radius.dart';
import 'package:weplay_music_streaming/constant/app_spacing.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';
import 'package:weplay_music_streaming/screens/onboard_popup.dart';

class OnboardingScreen extends StatefulWidget {
const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      "image": "assets/images/img1.png",
      "title": "Welcome to App",
      "subtitle": "Here's a brief overview of the app's key features.",
    },
    {
      "image": "assets/images/img1.png",
      "title": "Discover Music",
      "subtitle": "Find your favorite songs and artists easily.",
    },
    {
      "image": "assets/images/img1.png",
      "title": "Connect with Friends",
      "subtitle": "Share your playlists and enjoy music together.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x6,
                      vertical: AppSpacing.x6,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            _slides[index]["image"]!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        Text(
                          _slides[index]["title"]!,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: AppText.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spaceY3),
                        Text(
                          _slides[index]["subtitle"]!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spaceY6),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x6,
                AppSpacing.x6,
                AppSpacing.x6,
                AppSpacing.x8,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppColors.surface,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                        ),
                      ),
                      builder: (_) => const LoginPopup(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.xl,
                    ),
                  ),
                  child: const Text(
                    'Get started',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
