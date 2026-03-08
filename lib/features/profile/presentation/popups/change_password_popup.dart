import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/utils/mysnack_utils.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_button.dart';
import 'package:weplay_music_streaming/core/widgets/text_field/app_text_field.dart';
import 'package:weplay_music_streaming/features/profile/presentation/state/profile_state.dart';
import 'package:weplay_music_streaming/features/profile/presentation/view_model/profile_view_model.dart';

class ChangePasswordPopup extends ConsumerStatefulWidget {
  const ChangePasswordPopup({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChangePasswordPopup(),
    );
  }

  @override
  ConsumerState<ChangePasswordPopup> createState() => _ChangePasswordPopupState();
}

class _ChangePasswordPopupState extends ConsumerState<ChangePasswordPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _hideOldPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty) {
      MysnackUtils.showError(context, 'Enter your old password');
      return;
    }

    if (newPassword.length < 6) {
      MysnackUtils.showError(context, 'New password must be at least 6 characters');
      return;
    }

    if (newPassword != confirmPassword) {
      MysnackUtils.showError(context, 'New passwords do not match');
      return;
    }

    if (oldPassword == newPassword) {
      MysnackUtils.showInfo(context, 'Choose a different new password');
      return;
    }

    await ref.read(profileViewModelProvider.notifier).updateUser(
          password: newPassword,
          successMessage: 'Password changed successfully',
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (!mounted) {
        return;
      }

      if (previous?.status == ProfileStatus.loading && next.status == ProfileStatus.success) {
        Navigator.of(context).pop();
      }

      if (previous?.status == ProfileStatus.loading && next.status == ProfileStatus.error) {
        MysnackUtils.showError(
          context,
          next.errorMessage ?? 'Failed to change password',
        );
      }
    });

    final profileState = ref.watch(profileViewModelProvider);
    final isLoading = profileState.status == ProfileStatus.loading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: AppSpacing.px4.add(const EdgeInsets.only(top: 12, bottom: 24)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  AppSpacing.gap4,
                  Text(
                    'Change Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  AppSpacing.gap2,
                  Text(
                    'Enter your current password and choose a new password for your account.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  AppSpacing.gap6,
                  AppTextField(
                    controller: _oldPasswordController,
                    hint: 'Old password',
                    prefixIcon: Icons.lock_outline,
                    obscure: _hideOldPassword,
                    suffixIcon: _hideOldPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    onSuffixTap: () {
                      setState(() {
                        _hideOldPassword = !_hideOldPassword;
                      });
                    },
                  ),
                  AppSpacing.gap4,
                  AppTextField(
                    controller: _newPasswordController,
                    hint: 'New password',
                    prefixIcon: Icons.lock_outline,
                    obscure: _hideNewPassword,
                    suffixIcon: _hideNewPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    onSuffixTap: () {
                      setState(() {
                        _hideNewPassword = !_hideNewPassword;
                      });
                    },
                  ),
                  AppSpacing.gap4,
                  AppTextField(
                    controller: _confirmPasswordController,
                    hint: 'Confirm new password',
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
                  AppSpacing.gap6,
                  AppButton(
                    text: 'Change Password',
                    onPressed: isLoading ? null : _changePassword,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}