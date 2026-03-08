import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/app/app.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_colors.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/mysnack_utils.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_button.dart';
import 'package:weplay_music_streaming/core/widgets/text_field/app_text_field.dart';
import 'package:weplay_music_streaming/features/auth/presentation/screens/login_screen.dart';
import 'package:weplay_music_streaming/features/forgot_password/presentation/state/reset_password_state.dart';
import 'package:weplay_music_streaming/features/forgot_password/presentation/view_model/reset_password_view_model.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? initialToken;

  const ResetPasswordScreen({
    super.key,
    this.initialToken,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  bool get _hasFetchedToken =>
      (widget.initialToken?.trim().isNotEmpty ?? false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final extractedToken = widget.initialToken?.trim() ?? '';
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (extractedToken.isEmpty) {
      MysnackUtils.showError(
        context,
        'Reset token was not fetched. Open the reset link from your email again.',
      );
      return;
    }

    if (password.length < 6) {
      MysnackUtils.showError(context, 'Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      MysnackUtils.showError(context, 'Passwords do not match');
      return;
    }

    ref.read(resetPasswordViewModelProvider.notifier).resetPassword(
      token: extractedToken,
          newPassword: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(resetPasswordViewModelProvider);
    final isLoading = state.status == ResetPasswordStatus.loading;

    ref.listen<ResetPasswordState>(resetPasswordViewModelProvider, (previous, next) {
      if (!mounted) {
        return;
      }

      if (previous?.status == ResetPasswordStatus.loading &&
          next.status == ResetPasswordStatus.success) {
        MysnackUtils.showSuccess(
          context,
          next.successMessage ?? 'Password has been reset successfully.',
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) {
            return;
          }

          appNavigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        });
      }

      if (previous?.status == ResetPasswordStatus.loading &&
          next.status == ResetPasswordStatus.error) {
        MysnackUtils.showError(
          context,
          next.errorMessage ?? 'Failed to reset password',
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
                              color: AppColors.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_reset,
                              color: theme.colorScheme.primary,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        Center(
                          child: Text(
                            'Reset password',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: AppText.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY3),
                        Center(
                          child: Text(
                            'Your mobile email link should open this screen directly and fetch the reset token automatically.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.inputFill,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.vpn_key_outlined,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _hasFetchedToken ? 'Token fetched' : 'Token not fetched',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: _hasFetchedToken
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                    fontWeight: AppText.medium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _hasFetchedToken
                              ? 'Reset token received from the app link.'
                              : 'Open the reset link from your email on this device to continue.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        AppTextField(
                          controller: _passwordController,
                          hint: 'New password',
                          error: 'Enter a new password',
                          prefixIcon: Icons.lock_outline,
                          obscure: _hidePassword,
                          suffixIcon: _hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onSuffixTap: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        AppTextField(
                          controller: _confirmPasswordController,
                          hint: 'Confirm new password',
                          error: 'Confirm your new password',
                          prefixIcon: Icons.lock_outline,
                          obscure: _hideConfirmPassword,
                          suffixIcon: _hideConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onSuffixTap: () {
                            setState(() {
                              _hideConfirmPassword = !_hideConfirmPassword;
                            });
                          },
                        ),
                        if (state.status == ResetPasswordStatus.success &&
                            state.successMessage != null) ...[
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
                                    state.successMessage!,
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
                        if (state.status == ResetPasswordStatus.error &&
                            state.errorMessage != null) ...[
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
                                    state.errorMessage!,
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
                        AppButton(
                          text: 'Reset password',
                          onPressed: isLoading || !_hasFetchedToken ? null : _submit,
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: AppSpacing.spaceY4),
                        TextButton(
                          onPressed: () {
                            AppRoutes.pushReplacement(context, const LoginScreen());
                          },
                          child: const Text('Back to login'),
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