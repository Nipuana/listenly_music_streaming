import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:weplay_music_streaming/features/onboarding/presentation/screens/onboarding_screen.dart';

class FlutterSplashScreen extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;
  const FlutterSplashScreen({super.key, this.onComplete});

  @override
  ConsumerState<FlutterSplashScreen> createState() => _FlutterSplashScreenState();
}

class _FlutterSplashScreenState extends ConsumerState<FlutterSplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _logoFadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _navigateToNext();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  void _startAnimations() async {
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    _slideController.forward();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final userSessionService = ref.read(userSessionServiceProvider);
    final isLoggedIn =  userSessionService.isLoggedIn();
    
    if (isLoggedIn) {
      AppRoutes.pushReplacement(context, DashboardScreen());
    } else {
      AppRoutes.pushReplacement(context, OnboardingScreen());
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    final logoSize = screenWidth < 360 ? 120.0 : 150.0;
    final titleFontSize = screenWidth < 360 ? 36.0 : 44.0;
    final subtitleFontSize = screenWidth < 360 ? 14.0 : 16.0;
    
    // Get theme brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0a0a0a) : const Color(0xFFf5f5f5);
    final accentColor = isDark ? AppColors.primary : AppColors.primary;
    final textColor = isDark ? Colors.white : const Color(0xFF1a1a1a);
    final subtextColor = isDark ? Colors.white70 : const Color(0xFF666666);
    
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo Section - Clean and minimal
              AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: logoSize,
                        height: logoSize,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentColor.withOpacity(0.1),
                          border: Border.all(
                            color: accentColor.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              // App Name and Tagline
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Listenly',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your music, your way',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w400,
                          color: subtextColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // Minimal loading indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(5, (i) {
                        return AnimatedBuilder(
                          animation: _scaleController,
                          builder: (context, child) {
                            double delay = i * 0.15;
                            double value = (_scaleController.value - delay).clamp(0.0, 1.0);
                            double height = 3 + (16 * (0.5 + 0.5 * sin(value * 2 * pi)));
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2.5),
                              width: 3,
                              height: height,
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(1.5),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
