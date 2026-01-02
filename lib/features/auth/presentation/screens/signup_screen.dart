import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/widgets/text_field/app_text_field.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_button.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_social_button.dart';
import 'package:weplay_music_streaming/features/auth/presentation/screens/login_screen.dart';
import 'package:weplay_music_streaming/core/widgets/logo_widget.dart';
import 'package:weplay_music_streaming/core/widgets/my_snack.dart';


class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    });
  }

  void _toggleTerms() {
    setState(() {
      _agreedToTerms = !_agreedToTerms;
    });
  }

  void _onTermsChanged(bool? value) {
    setState(() {
      _agreedToTerms = value ?? false;
    });
  }

  void _onLoginPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _onSignupPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      MySnack.show(
        context,
        message: 'Passwords do not match',
      );
      return;
    }
    if (!_agreedToTerms) {
      MySnack.show(
        context,
        message: 'You must agree to the Terms & Conditions and Privacy Policy',
      );
      return;
    }
    MySnack.show(
      context,
      message: 'Account created',
    );
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
                          'Create your account',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: AppText.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spaceY3),
                        Text(
                          'Join the community and start streaming right away.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spaceY6),
                        _buildUsernameField(theme),
                        const SizedBox(height: AppSpacing.spaceY4),
                        _buildEmailField(theme),
                        const SizedBox(height: AppSpacing.spaceY4),
                        _buildPasswordField(theme),
                        const SizedBox(height: AppSpacing.spaceY3 / 1.5),
                        Text(
                          'Must be at least 8 characters long',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        _buildConfirmPasswordField(theme),
                        const SizedBox(height: AppSpacing.spaceY3 / 1.5),
                        _buildTermsRow(theme),
                        const SizedBox(height: AppSpacing.spaceY6),
                        AppButton(
                          text: 'Sign up',
                          onPressed: _onSignupPressed,
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
                          iconSize: 25,
                          onPressed: () {},
                        ),
                        const SizedBox(height: AppSpacing.spaceY3),
                        AppSocialButton(
                          text: 'Continue with Apple',
                          icon: FontAwesomeIcons.apple,
                          iconSize: 30,
                          onPressed: () {},
                        ),
                        const SizedBox(height: AppSpacing.spaceY6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: _onLoginPressed,
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

  Widget _buildUsernameField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: AppText.medium,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceY3 / 3),
        AppTextField(
          hint: 'Your username',
          error: 'Enter your username',
          prefixIcon: Icons.person_outline,
          controller: _usernameController,
        ),
      ],
    );
  }

  Widget _buildEmailField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          prefixIcon: Icons.email_outlined,
          controller: _emailController,
        ),
      ],
    );
  }

  Widget _buildPasswordField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: AppText.medium,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceY3 / 3),
        AppTextField(
          hint: 'Create a strong password',
          error: 'Enter your password',
          prefixIcon: Icons.lock_outline,
          obscure: _isPasswordHidden,
          controller: _passwordController,
          suffixIcon: _isPasswordHidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixTap: _togglePasswordVisibility,
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: AppText.medium,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceY3 / 3),
        AppTextField(
          hint: 'Re-enter your password',
          error: 'Confirm your password',
          prefixIcon: Icons.lock_outline,
          obscure: _isConfirmPasswordHidden,
          controller: _confirmPasswordController,
          suffixIcon: _isConfirmPasswordHidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixTap: _toggleConfirmPasswordVisibility,
        ),
      ],
    );
  }

  Widget _buildTermsRow(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: _onTermsChanged,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: _toggleTerms,
              child: RichText(
                text: TextSpan(
                  text: 'I agree to the ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: AppText.medium,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: AppText.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}