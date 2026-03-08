import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:weplay_music_streaming/app/app.dart';
import 'package:weplay_music_streaming/app/theme/theme_mode_controller.dart';
import 'package:weplay_music_streaming/features/profile/presentation/screens/profile_screen.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';

class MotionShortcutOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const MotionShortcutOverlay({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<MotionShortcutOverlay> createState() =>
      _MotionShortcutOverlayState();
}

class _MotionShortcutOverlayState extends ConsumerState<MotionShortcutOverlay>
    with WidgetsBindingObserver {
  static const double _shakeThreshold = 2.8;
  static const Duration _requiredShakeDuration = Duration(seconds: 2);
  static const Duration _maxShakeGap = Duration(milliseconds: 220);
  static const Duration _cooldown = Duration(seconds: 2);

  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastTriggerAt;
  DateTime? _shakeStartedAt;
  DateTime? _lastStrongMotionAt;
  bool _isPopupOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startListening();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startListening();
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _accelerometerSubscription?.cancel();
      _accelerometerSubscription = null;
    }
  }

  void _startListening() {
    if (_accelerometerSubscription != null) {
      return;
    }

    _accelerometerSubscription = userAccelerometerEventStream().listen(
      _handleAccelerometerEvent,
      onError: (_, _) {},
      cancelOnError: false,
    );
  }

  void _handleAccelerometerEvent(UserAccelerometerEvent event) {
    if (_isPopupOpen || !mounted) {
      return;
    }

    final now = DateTime.now();
    if (_lastTriggerAt != null && now.difference(_lastTriggerAt!) < _cooldown) {
      return;
    }

    final magnitude = math.sqrt(
      (event.x * event.x) + (event.y * event.y) + (event.z * event.z),
    );

    if (magnitude < _shakeThreshold) {
      if (_lastStrongMotionAt != null &&
          now.difference(_lastStrongMotionAt!) > _maxShakeGap) {
        _resetShakeTracking();
      }
      return;
    }

    if (_lastStrongMotionAt != null &&
        now.difference(_lastStrongMotionAt!) > _maxShakeGap) {
      _resetShakeTracking();
    }

    _shakeStartedAt ??= now;
    _lastStrongMotionAt = now;

    if (now.difference(_shakeStartedAt!) < _requiredShakeDuration) {
      return;
    }

    _lastTriggerAt = now;
    _resetShakeTracking();
    unawaited(_openMotionSheet());
  }

  void _resetShakeTracking() {
    _shakeStartedAt = null;
    _lastStrongMotionAt = null;
  }

  Future<void> _openMotionSheet() async {
    final navigator = appNavigatorKey.currentState;
    final popupContext = navigator?.overlay?.context ?? appNavigatorKey.currentContext;
    if (popupContext == null || navigator == null || _isPopupOpen) {
      return;
    }

    _isPopupOpen = true;
    try {
      await showModalBottomSheet<void>(
        context: popupContext,
        isScrollControlled: true,
        showDragHandle: true,
        useRootNavigator: true,
        builder: (_) => const _MotionShortcutSheet(),
      );
    } finally {
      _isPopupOpen = false;
      _lastTriggerAt = DateTime.now();
      _resetShakeTracking();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _MotionShortcutSheet extends ConsumerWidget {
  const _MotionShortcutSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeControllerProvider);
    final session = ref.watch(userSessionServiceProvider);
    final isLoggedIn = session.isLoggedIn();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            24 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Motion Shortcuts',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Shake your device to open quick actions from any screen.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Theme',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _ThemeModeOption(
                title: 'System',
                subtitle: 'Match the device appearance',
                icon: Icons.phone_android,
                isSelected: themeMode == ThemeMode.system,
                onTap: () async {
                  await ref
                      .read(themeModeControllerProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              _ThemeModeOption(
                title: 'Light',
                subtitle: 'Use the light theme everywhere',
                icon: Icons.light_mode_outlined,
                isSelected: themeMode == ThemeMode.light,
                onTap: () async {
                  await ref
                      .read(themeModeControllerProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              _ThemeModeOption(
                title: 'Dark',
                subtitle: 'Use the dark theme everywhere',
                icon: Icons.dark_mode_outlined,
                isSelected: themeMode == ThemeMode.dark,
                onTap: () async {
                  await ref
                      .read(themeModeControllerProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              if (isLoggedIn) ...[
                const SizedBox(height: 12),
                Text(
                  'Account',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Go to Profile'),
                  subtitle: const Text('Open your profile screen'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    appNavigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeModeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(
          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: isSelected ? primaryColor : theme.iconTheme.color,
        ),
      ),
    );
  }
}