import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/widgets/text_field/app_text_field.dart';
import 'package:weplay_music_streaming/features/auth/presentation/screens/signup_screen.dart';
import 'package:weplay_music_streaming/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:weplay_music_streaming/features/forgot_password/presentation/forgot_password_screen.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_button.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_social_button.dart';
import 'package:weplay_music_streaming/core/widgets/logo_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isPasswordHidden = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x6),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const LogoWidget(size: 96),
                        const SizedBox(height: AppSpacing.spaceY6),
                        Text(
                          'Welcome back',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: AppText.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spaceY3),
                        Text(
                          'Log in to continue discovering and streaming your favorite tracks.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spaceY6),
                        Text(
                          'Email',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: AppText.medium,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY3 / 3),
                        AppTextField(
                          hint: 'your@email.com',
                          error: 'Enter your email',
                          controller: emailController,
                          prefixIcon: Icons.email_outlined,
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        Text(
                          'Password',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: AppText.medium,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY3 / 3),
                        AppTextField(
                          controller: passwordController,
                          hint: 'Enter your password',
                          error: 'Please enter your password',
                          prefixIcon: Icons.lock_outline,
                          obscure: _isPasswordHidden,
                          suffixIcon: _isPasswordHidden
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onSuffixTap: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                            ),
                            child: const Text('Forgot password?'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        AppButton(
                          text: 'Log in',
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DashboardScreen(),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: AppSpacing.spaceY6),
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('OR'),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        AppSocialButton(
                          text: 'Continue with Google',
                          icon: FontAwesomeIcons.google,
                          iconSize:25,
                          onPressed: () {},
                        ),
                        const SizedBox(height: AppSpacing.spaceY3),
                        AppSocialButton(
                          text: 'Continue with Apple',
                          icon: Icons.apple,
                          iconSize: 32,
                          onPressed: () {},
                        ),
                        const SizedBox(height: AppSpacing.spaceY6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                              ),
                              child: const Text('Sign up'),
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