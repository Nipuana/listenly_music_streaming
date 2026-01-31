import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/core/utils/mysnack_utils.dart';
import 'package:weplay_music_streaming/core/widgets/buttons/app_button.dart';
import 'package:weplay_music_streaming/core/widgets/text_field/app_text_field.dart';
import 'package:weplay_music_streaming/features/profile/presentation/state/profile_state.dart';
import 'package:weplay_music_streaming/features/profile/presentation/view_model/profile_view_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  String? _currentUsername;
  String? _currentEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _usernameController = TextEditingController(text: _currentUsername);
    _emailController = TextEditingController(text: _currentEmail);
  }

  void _loadUserData() {
    final userSessionService = ref.read(userSessionServiceProvider);
    _currentUsername = userSessionService.getCurrentUserUsername();
    _currentEmail = userSessionService.getCurrentUserEmail();

    if (mounted) {
      _usernameController.text = _currentUsername ?? '';
      _emailController.text = _currentEmail ?? '';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();

      await ref.read(profileViewModelProvider.notifier).updateUser(
            username: username != _currentUsername ? username : null,
            email: email != _currentEmail ? email : null,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.status == ProfileStatus.success) {
        MysnackUtils.showSuccess(context, 'Profile updated successfully');
        AppRoutes.pop(context);
      } else if (next.status == ProfileStatus.error) {
        MysnackUtils.showError(
          context,
          next.errorMessage ?? 'Failed to update profile',
        );
      }
    });

    final profileState = ref.watch(profileViewModelProvider);
    final isLoading = profileState.status == ProfileStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.px4,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSpacing.gap6,

                // Username Field
                AppTextField(
                  controller: _usernameController,
                  hint: 'Username',
                  prefixIcon: Icons.person_outline,
                ),
                AppSpacing.gap4,

                // Email Field
                AppTextField(
                  controller: _emailController,
                  hint: 'Email',
                  prefixIcon: Icons.email_outlined,
                ),
                AppSpacing.gap6,

                // Save Button
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
    );
  }
}
