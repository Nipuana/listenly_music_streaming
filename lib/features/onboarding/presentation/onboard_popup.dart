import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_button.dart';
import 'package:weplay_music_streaming/features/auth/presentation/screens/login_screen.dart';
import 'package:weplay_music_streaming/features/auth/presentation/screens/signup_screen.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';

class LoginPopup extends StatelessWidget {
const LoginPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;
    final horizontalPadding = isSmallScreen ? 10.0 : AppSpacing.x6;
    final verticalPadding = isSmallScreen ? 10.0 : AppSpacing.x4;
    Color fadedTextSecondary(double opacity) {
      final base = theme.brightness == Brightness.dark ? AppColors.darkTextSecondary : AppColors.textSecondary;
      return base.withAlpha((opacity * 255).round());
    }
    Color getPrimaryTextColor() => theme.brightness == Brightness.dark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    
    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: verticalPadding,
        bottom: MediaQuery.of(context).viewInsets.bottom + verticalPadding,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isSmallScreen ? screenWidth * 0.98 : 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, size: 22),
                color: fadedTextSecondary(0.7),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceY3),
            Text(
              'Login or sign up',
              style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: AppText.bold,
                    color: getPrimaryTextColor(),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceY3),
            if (!isSmallScreen)
              Text(
                'Please select your preferred method to continue setting up your account.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                      color: fadedTextSecondary(0.7),
                    ),
              ),
            const SizedBox(height: AppSpacing.spaceY4),
            AppButton(
              text: isSmallScreen ? 'Log in' : 'Already have an account? ',
              icon: const Icon(Icons.mail_outline, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                AppRoutes.push(context, const LoginScreen());
              },
            ),
            const SizedBox(height: AppSpacing.spaceY3),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  AppRoutes.push(context, const SignupScreen());
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
                  foregroundColor: getPrimaryTextColor(),
                ),
                child: Text(isSmallScreen ? 'Sign up' : 'Sign up with us'),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceY4),
            if (!isSmallScreen)
              Text(
                'If you are creating a new account, Terms & Conditions and Privacy Policy will apply.',
                style: theme.textTheme.bodySmall?.copyWith(
                      color: fadedTextSecondary(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: AppSpacing.spaceY3),
          ],
        ),
      ),
    );
}
}