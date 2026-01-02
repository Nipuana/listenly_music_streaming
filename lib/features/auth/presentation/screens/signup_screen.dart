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
  bool _isPasswordHidden = true;
  bool _agreedToTerms = false;

  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _disposeControllers([
      usernameController,
      emailController,
      passwordController,
      confirmPasswordController,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildSignupScreen(
        context: context,
        theme: Theme.of(context),
        formKey: _formKey,
        usernameController: usernameController,
        emailController: emailController,
        passwordController: passwordController,
        confirmPasswordController: confirmPasswordController,
        isPasswordHidden: _isPasswordHidden,
        onTogglePassword: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
        agreedToTerms: _agreedToTerms,
        onTermsChanged: (value) => setState(() => _agreedToTerms = value),
      );
}

void _disposeControllers(List<TextEditingController> controllers) {
  for (final c in controllers) {
    c.dispose();
  }
}

Widget buildSignupScreen({
  required BuildContext context,
  required ThemeData theme,
  required GlobalKey<FormState> formKey,
  required TextEditingController usernameController,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController confirmPasswordController,
  required bool isPasswordHidden,
  required VoidCallback onTogglePassword,
  required bool agreedToTerms,
  required ValueChanged<bool> onTermsChanged,
}) {
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
                  key: formKey,
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
                        controller: usernameController,
                      ),
                      const SizedBox(height: AppSpacing.spaceY4),
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
                        controller: emailController,
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
                        hint: 'Create a strong password',
                        error: 'Enter your password',
                        prefixIcon: Icons.lock_outline,
                        obscure: isPasswordHidden,
                        controller: passwordController,
                        suffixIcon: isPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        onSuffixTap: onTogglePassword,
                      ),
                      const SizedBox(height: AppSpacing.spaceY3 / 1.5),
                      Text(
                        'Must be at least 8 characters long',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spaceY4),
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
                        obscure: isPasswordHidden,
                        controller: confirmPasswordController,
                        suffixIcon: isPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        onSuffixTap: onTogglePassword,
                      ),
                      const SizedBox(height: AppSpacing.spaceY3 / 1.5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: agreedToTerms,
                            onChanged: (value) => onTermsChanged(value ?? false),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
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
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spaceY6),
                      AppButton(
                        text: 'Sign up',
                        onPressed: () => onSignupPressed(
                          context: context,
                          formKey: formKey,
                          passwordController: passwordController,
                          confirmPasswordController: confirmPasswordController,
                          agreedToTerms: agreedToTerms,
                        ),
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
                            onPressed: () => onLoginPressed(context),
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

void onSignupPressed({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController passwordController,
  required TextEditingController confirmPasswordController,
  required bool agreedToTerms,
}) {
  if (!(formKey.currentState?.validate() ?? false)) {
    return;
  }
  if (passwordController.text != confirmPasswordController.text) {
    MySnack.show(
      context,
      message: 'Passwords do not match',
    );
    return;
  }
  if (!agreedToTerms) {
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

void onLoginPressed(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}