import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/widgets/text_field/app_text_field.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_button.dart';
import 'package:weplay_music_streaming/core/utils/mysnack_utils.dart';
import 'package:weplay_music_streaming/features/auth/presentation/screens/login_screen.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/features/forgot_password/presentation/state/forgot_password_state.dart';
import 'package:weplay_music_streaming/features/forgot_password/presentation/view_model/forgot_password_view_model.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(value);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final forgotPasswordState = ref.watch(forgotPasswordViewModelProvider);
    final isLoading = forgotPasswordState.status == ForgotPasswordStatus.loading;

    ref.listen<ForgotPasswordState>(forgotPasswordViewModelProvider, (previous, next) {
      if (!mounted) {
        return;
      }

      if (previous?.status == ForgotPasswordStatus.loading &&
          next.status == ForgotPasswordStatus.success) {
        MysnackUtils.showSuccess(
          context,
          next.successMessage ?? 'Reset link sent',
        );
      }

      if (previous?.status == ForgotPasswordStatus.loading &&
          next.status == ForgotPasswordStatus.error) {
        MysnackUtils.showError(
          context,
          next.errorMessage ?? 'Failed to send reset link',
        );
      }
    });

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
                            AppRoutes.pushReplacement(context, const LoginScreen());
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
                              color: AppColors.primary.withValues(alpha:0.12),
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
                          isLoading: isLoading,
                          onPressed: isLoading ? null : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final email = emailController.text.trim();
                              if (!_isValidEmail(email)) {
                                MysnackUtils.showError(context, 'Enter a valid email address');
                                return;
                              }

                              ref
                                  .read(forgotPasswordViewModelProvider.notifier)
                                  .sendResetLink(email);
                            }
                          },
                        ),
                        if (forgotPasswordState.status == ForgotPasswordStatus.success &&
                            forgotPasswordState.successMessage != null) ...[
                          const SizedBox(height: AppSpacing.spaceY4),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFB7DFBC)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Color(0xFF388E3C),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    forgotPasswordState.successMessage!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF388E3C),
                                      fontWeight: AppText.medium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (forgotPasswordState.status == ForgotPasswordStatus.error &&
                            forgotPasswordState.errorMessage != null) ...[
                          const SizedBox(height: AppSpacing.spaceY4),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDEDED),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFF5C2C7)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: Color(0xFFD32F2F),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    forgotPasswordState.errorMessage!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFFD32F2F),
                                      fontWeight: AppText.medium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                                AppRoutes.pushReplacement(context, const LoginScreen());
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
