import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/core/utils/mysnack_utils.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_button.dart';
import 'package:weplay_music_streaming/core/widgets/text_field/app_text_field.dart';
import 'package:weplay_music_streaming/features/profile/presentation/popups/additional_info_popup.dart';
import 'package:weplay_music_streaming/features/profile/presentation/state/profile_state.dart';
import 'package:weplay_music_streaming/features/profile/presentation/view_model/profile_view_model.dart';

class EditProfilePopup extends ConsumerStatefulWidget {
  const EditProfilePopup({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditProfilePopup(),
    );
  }

  @override
  ConsumerState<EditProfilePopup> createState() => _EditProfilePopupState();
}

class _EditProfilePopupState extends ConsumerState<EditProfilePopup> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;

  String? _currentUsername;
  String? _currentEmail;

  @override
  void initState() {
    super.initState();
    final session = ref.read(userSessionServiceProvider);
    _currentUsername = session.getCurrentUserUsername() ?? '';
    _currentEmail = session.getCurrentUserEmail() ?? '';
    _usernameController = TextEditingController(text: _currentUsername);
    _emailController = TextEditingController(text: _currentEmail);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(value);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();

    if (!_isValidEmail(email)) {
      MysnackUtils.showError(context, 'Enter a valid email address');
      return;
    }

    final usernameChanged = username != (_currentUsername ?? '');
    final emailChanged = email != (_currentEmail ?? '');

    if (!usernameChanged && !emailChanged) {
      MysnackUtils.showInfo(context, 'No profile changes to save');
      return;
    }

    await ref.read(profileViewModelProvider.notifier).updateUser(
          username: usernameChanged ? username : null,
          email: emailChanged ? email : null,
        );
  }

  Future<void> _openAdditionalInfo() async {
    await AdditionalInfoPopup.show(context);
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
          next.errorMessage ?? 'Failed to update profile',
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
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  AppSpacing.gap2,
                  Text(
                    'Update your username and email, or open additional info to edit more details.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  AppSpacing.gap6,
                  AppTextField(
                    controller: _usernameController,
                    hint: 'Username',
                    prefixIcon: Icons.person_outline,
                  ),
                  AppSpacing.gap4,
                  AppTextField(
                    controller: _emailController,
                    hint: 'Email',
                    prefixIcon: Icons.email_outlined,
                  ),
                  AppSpacing.gap4,
                  OutlinedButton.icon(
                    onPressed: _openAdditionalInfo,
                    icon: const Icon(Icons.badge_outlined),
                    label: const Text('Open Additional Info'),
                  ),
                  AppSpacing.gap6,
                  AppButton(
                    text: 'Save Changes',
                    onPressed: isLoading ? null : _saveProfile,
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