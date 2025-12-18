import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_colors.dart';
import 'package:weplay_music_streaming/constant/app_radius.dart';
import 'package:weplay_music_streaming/constant/app_spacing.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';
import 'package:weplay_music_streaming/screens/login_screen.dart';
import 'package:weplay_music_streaming/widget/buttons/app_button.dart';

class LoginPopup extends StatelessWidget {
const LoginPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.x6,
        right: AppSpacing.x6,
        top: AppSpacing.x4,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.x4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, size: 22),
              color: AppColors.textSecondary,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceY3),
          Text(
            'Login or sign up',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: AppText.bold,
                  color: AppColors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.spaceY3),
          Text(
            'Please select your preferred method to continue setting up your account.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.spaceY4),
          AppButton(
            text: 'Already have an account? Log in',
            icon: const Icon(Icons.mail_outline, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(height: AppSpacing.spaceY3),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
                foregroundColor: AppColors.textPrimary,
              ),
              child: const Text('Sign up with us'),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceY4),
          Text(
            'If you are creating a new account, Terms & Conditions and Privacy Policy will apply.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.spaceY3),
        ],
      ),
    );
  }
}
