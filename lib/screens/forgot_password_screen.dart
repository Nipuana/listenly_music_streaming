import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_colors.dart';
import 'package:weplay_music_streaming/constant/app_spacing.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';
import 'package:weplay_music_streaming/screens/login_screen.dart';
import 'package:weplay_music_streaming/widget/app_text_field.dart';
import 'package:weplay_music_streaming/widget/buttons/app_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x6,
              vertical: AppSpacing.x6,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x6),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_back, size: 20),
                          label: const Text('Back to login'),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        Center(
                          child: Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.mail_outline,
                              color: theme.colorScheme.primary,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        Center(
                          child: Text(
                            'Forgot password?',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: AppText.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY3),
                        Center(
                          child: Text(
                            "No worries! Enter your email and we'll send you a reset link.",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY6),
                        Text(
                          'Email address',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: AppText.medium,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY3 / 3),
                        AppTextField(
                          controller: emailController,
                          hint: 'your@email.com',
                          error: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        AppButton(
                          text: 'Send reset link',
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Reset link sent')),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Remember your password? ',
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                              ),
                              child: const Text('Log in'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
