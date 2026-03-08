import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/app/routes/app_routes.dart';
import 'package:weplay_music_streaming/features/auth/presentation/screens/login_screen.dart';
import 'package:weplay_music_streaming/features/auth/presentation/view_model/auth_view_model.dart';

class AdminMobileUnsupportedScreen extends ConsumerStatefulWidget {
  const AdminMobileUnsupportedScreen({super.key});

  @override
  ConsumerState<AdminMobileUnsupportedScreen> createState() => _AdminMobileUnsupportedScreenState();
}

class _AdminMobileUnsupportedScreenState extends ConsumerState<AdminMobileUnsupportedScreen> {
  bool _isLoggingOut = false;

  Future<void> _backToLogin() async {
    setState(() {
      _isLoggingOut = true;
    });

    await ref.read(authViewModelProvider.notifier).logout();

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoggingOut = false;
    });

    AppRoutes.pushAndRemoveUntil(context, const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Admin Account'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 72,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Mobile app does not support admin accounts',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Try using the web app to access admin features and management tools.',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isLoggingOut ? null : _backToLogin,
                        child: _isLoggingOut
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Back to Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
