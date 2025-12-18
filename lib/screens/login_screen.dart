import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/constant/app_colors.dart';
import 'package:weplay_music_streaming/constant/app_spacing.dart';
import 'package:weplay_music_streaming/constant/app_text.dart';
import 'package:weplay_music_streaming/screens/dashboard_screen.dart';
import 'package:weplay_music_streaming/screens/forgot_password_screen.dart';
import 'package:weplay_music_streaming/screens/signup_screen.dart';
import 'package:weplay_music_streaming/widget/app_text_field.dart';
import 'package:weplay_music_streaming/widget/buttons/app_button.dart';
import 'package:weplay_music_streaming/widget/buttons/app_social_button.dart';
import 'package:weplay_music_streaming/widget/logo_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                          icon: Icons.g_mobiledata,
                          onPressed: () {},
                        ),
                        const SizedBox(height: AppSpacing.spaceY3),
                        AppSocialButton(
                          text: 'Continue with Apple',
                          icon: Icons.apple,
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