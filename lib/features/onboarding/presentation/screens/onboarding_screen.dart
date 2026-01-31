import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/features/onboarding/presentation/onboard_popup.dart';


class OnboardingScreen extends StatefulWidget {
const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  late final List<Map<String, dynamic>> _slides;

  @override
  void initState() {
    super.initState();
    _slides = [
      {
        "icon": Icons.music_note_rounded,
        "title": "Discover Your Sound",
        "subtitle": "Explore millions of songs and discover new artists tailored to your taste.",
        "color": Color(0xFF6366F1),
      },
      {
        "icon": Icons.playlist_play_rounded,
        "title": "Create & Share Playlists",
        "subtitle": "Build your perfect playlist and share it with friends around the world.",
        "color": Color(0xFFEC4899),
      },
      {
        "icon": Icons.headphones_rounded,
        "title": "Listen Anywhere",
        "subtitle": "Enjoy your music offline, on any device, anytime, anywhere.",
        "color": Color(0xFF8B5CF6),
      },
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showGetStartedPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (_) => const LoginPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: AppSpacing.px4,
                child: TextButton(
                  onPressed: _showGetStartedPopup,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: AppText.semiBold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  final slideColor = slide["color"] as Color;
                  final slideIcon = slide["icon"] as IconData;
                  final slideTitle = slide["title"] as String;
                  final slideSubtitle = slide["subtitle"] as String;

                  return Padding(
                    padding: AppSpacing.px8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with border
                        Container(
                          padding: AppSpacing.p6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: slideColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            slideIcon,
                            size: 80,
                            color: slideColor,
                          ),
                        ),
                        AppSpacing.gapY12,
                        // Title
                        Text(
                          slideTitle,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: AppText.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.gapY4,
                        // Subtitle
                        Text(
                          slideSubtitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page indicators
            Padding(
              padding: AppSpacing.pb6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => Container(
                    margin: AppSpacing.mx1,
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(0.3),
                      borderRadius: AppRadius.sm,
                    ),
                  ),
                ),
              ),
            ),
            // Get Started Button
            Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.x6, 0, AppSpacing.x6, AppSpacing.x8),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _showGetStartedPopup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.lg,
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: AppText.semiBold,
                    ),
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
