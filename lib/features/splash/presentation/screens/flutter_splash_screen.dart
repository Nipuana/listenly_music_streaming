import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';

class FlutterSplashScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  const FlutterSplashScreen({super.key, this.onComplete});

  @override
  State<FlutterSplashScreen> createState() => _FlutterSplashScreenState();
}

class _FlutterSplashScreenState extends State<FlutterSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (widget.onComplete != null) {
        widget.onComplete!();
      } else {
        // Default: navigate to onboarding using AppRoutes with fade
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => OnboardingScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Stack(
        children: [
          // Animated circles background
          Positioned.fill(
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.25,
                  left: MediaQuery.of(context).size.width * 0.25,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Opacity(
                      opacity: 0.2,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: AppColors.white30,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.25,
                  right: MediaQuery.of(context).size.width * 0.25,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Opacity(
                      opacity: 0.2,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.white30,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo with bounce animation
                AnimatedBuilder(
                  animation: _bounceAnim,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, _bounceAnim.value),
                    child: child,
                  ),
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 70,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      color: Colors.white.withOpacity(0.8),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Tagline
                Text(
                  'Your music, your way',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.white90,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Loading indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        double delay = i * 0.2;
                        double value = (_controller.value - delay) % 1.0;
                        double dy = -8 * (1 - (value * 2 - 1).abs());
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.white80,
                            shape: BoxShape.circle,
                          ),
                          transform: Matrix4.translationValues(0, dy, 0),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          // Bottom decorative element
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.10,
              child: SizedBox(
                height: 80,
                child: CustomPaint(
                  painter: _BottomWavePainter(),
                  size: const Size(double.infinity, 80),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..cubicTo(
        size.width * 0.2, size.height * 0.5,
        size.width * 0.4, size.height * 0.1,
        size.width * 0.6, size.height * 0.3,
      )
      ..cubicTo(
        size.width * 0.8, size.height * 0.5,
        size.width * 0.9, size.height * 0.2,
        size.width, size.height * 0.3,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
