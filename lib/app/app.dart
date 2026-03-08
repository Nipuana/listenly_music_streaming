import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:weplay_music_streaming/app/theme/app_theme.dart';
import 'package:weplay_music_streaming/app/theme/theme_mode_controller.dart';
import 'package:weplay_music_streaming/app/widgets/motion_shortcut_overlay.dart';
import 'package:weplay_music_streaming/core/services/auth/auth_session_manager.dart';
import 'package:weplay_music_streaming/features/auth/presentation/screens/login_screen.dart';
import 'package:weplay_music_streaming/features/forgot_password/presentation/screens/reset_password_screen.dart';
import 'package:weplay_music_streaming/features/splash/presentation/screens/flutter_splash_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  String? _lastHandledToken;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      _handleIncomingUri(initialUri);
    } catch (_) {}

    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleIncomingUri,
      onError: (_) {},
    );
  }

  void _handleIncomingUri(Uri? uri) {
    if (uri == null) {
      return;
    }

    final token = _extractResetToken(uri);
    if (token == null || token.isEmpty || token == _lastHandledToken) {
      return;
    }

    _lastHandledToken = token;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = appNavigatorKey.currentState;
      if (navigator == null) {
        return;
      }

      navigator.push(
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(initialToken: token),
        ),
      );
    });
  }

  String? _extractResetToken(Uri uri) {
    final scheme = uri.scheme.toLowerCase();
    final host = uri.host.toLowerCase();
    final normalizedPath = uri.path.toLowerCase();

    final isSupportedResetLink =
        (scheme == 'weplay' && host == 'reset-password') ||
        normalizedPath.contains('reset-password');

    if (!isSupportedResetLink) {
      return null;
    }

    final queryToken = uri.queryParameters['token'];
    if (queryToken != null && queryToken.isNotEmpty) {
      return queryToken;
    }

    if (normalizedPath.contains('reset-password') && uri.pathSegments.isNotEmpty) {
      final lastSegment = uri.pathSegments.last;
      if (lastSegment.isNotEmpty && lastSegment.toLowerCase() != 'reset-password') {
        return lastSegment;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeControllerProvider);

    ref.listen<int>(authSessionInvalidationProvider, (previous, next) {
      if (next <= 0 || previous == next) {
        return;
      }

      appNavigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    });

    return MaterialApp(
      navigatorKey: appNavigatorKey,
      title: 'Lost & Found',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (context, child) {
        return MotionShortcutOverlay(
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const FlutterSplashScreen(),
    );
  }
}
