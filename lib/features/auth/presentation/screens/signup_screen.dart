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
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/core/widgets/logo_widget.dart';
import 'package:weplay_music_streaming/core/utils/mysnack_utils.dart';
import 'package:weplay_music_streaming/features/auth/presentation/state/auth_state.dart';
import 'package:weplay_music_streaming/features/auth/presentation/view_model/auth_view_model.dart';


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
    AppRoutes.push(context, const LoginScreen());
  }

  Future<void> _onSignupPressed() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      MysnackUtils.showError(context, 'Passwords do not match');
      return;
    }
    if (!_agreedToTerms) {
      MysnackUtils.showWarning(context, 'You must agree to the Terms & Conditions and Privacy Policy');
      return;
    }
    if (_formKey.currentState!.validate()) {
      ref.read(authViewModelProvider.notifier).register(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    //listen for state changes
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        MysnackUtils.showError(
          context,
          next.errorMessage ?? 'Registration failed');
      }
      else if (next.status == AuthStatus.registered) {
        AppRoutes.pushReplacement(context, const LoginScreen());
        MysnackUtils.showSuccess(context, 'Registration successful! Please log in.');
      }
    });
    


    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final horizontalPadding = isSmallScreen ? 4.0 : AppSpacing.x2;
    final maxWidth = isSmallScreen ? screenWidth * 0.98 : 480.0;
    final cardPadding = isSmallScreen ? 8.0 : AppSpacing.x2;
    Color getPrimaryTextColor() => theme.brightness == Brightness.dark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    Color getSecondaryTextColor() => theme.brightness == Brightness.dark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: AppSpacing.x2,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.spaceY4),
                        const LogoWidget(size: 88),
                        const SizedBox(height: AppSpacing.spaceY4),
                        Text(
                          'Create your account',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: AppText.bold,
                            color: getPrimaryTextColor(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spaceY3),
                        Text(
                          'Join the community and start streaming right away.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: getSecondaryTextColor(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spaceY6),
                        // Username
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
                        const SizedBox(height: AppSpacing.spaceY4),
                        // Email
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
                        const SizedBox(height: AppSpacing.spaceY4),
                        // Password
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
                        const SizedBox(height: AppSpacing.spaceY3 / 1.5),
                        Text(
                          'Must be at least 8 characters long',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        // Confirm Password
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
                        const SizedBox(height: AppSpacing.spaceY3 / 1.5),
                        // Terms & Conditions
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _agreedToTerms,
                                onChanged: _onTermsChanged,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: _toggleTerms,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'I agree to the ',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: getSecondaryTextColor(),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontWeight: AppText.medium,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' and ',
                                        style: TextStyle(
                                          color: getSecondaryTextColor(),
                                        ),
                                      ),
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
                          onPressed: _onSignupPressed,
                          isLoading: authState.status == AuthStatus.loading,
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
                          assetIcon: 'assets/icons/google_icon1.png',
                          iconSize: 22,
                          onPressed: () {},
                        ),
                        const SizedBox(height: AppSpacing.spaceY3),
                        AppSocialButton(
                          text: 'Continue with Apple',
                          icon: FontAwesomeIcons.apple,
                          iconSize: 26,
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
}