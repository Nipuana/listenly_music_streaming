import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';

final authSessionInvalidationProvider =
    NotifierProvider<AuthSessionInvalidationNotifier, int>(
  AuthSessionInvalidationNotifier.new,
);

class AuthSessionInvalidationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void notifyInvalidation() {
    state++;
  }
}

final authSessionManagerProvider = Provider<AuthSessionManager>((ref) {
  return AuthSessionManager(
    ref: ref,
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthSessionManager {
  static const String tokenKey = 'auth_token';

  final Ref _ref;
  final UserSessionService _userSessionService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isHandlingExpiry = false;

  AuthSessionManager({
    required Ref ref,
    required UserSessionService userSessionService,
  })  : _ref = ref,
        _userSessionService = userSessionService;

  Future<String?> readToken() {
    return _secureStorage.read(key: tokenKey);
  }

  Future<void> saveToken(String token) {
    return _secureStorage.write(key: tokenKey, value: token);
  }

  Future<void> clearAuthSession({bool notify = false}) async {
    await _secureStorage.delete(key: tokenKey);
    await _userSessionService.clearSession();

    if (notify) {
      _ref.read(authSessionInvalidationProvider.notifier).notifyInvalidation();
    }
  }

  Future<bool> hasValidSession() async {
    if (!_userSessionService.isLoggedIn()) {
      return false;
    }

    final token = await readToken();
    if (token == null || token.isEmpty || JwtDecoder.isExpired(token)) {
      await clearAuthSession();
      return false;
    }

    return true;
  }

  Future<bool> isTokenExpired() async {
    final token = await readToken();
    if (token == null || token.isEmpty) {
      return true;
    }
    return JwtDecoder.isExpired(token);
  }

  Future<void> handleExpiredSession() async {
    if (_isHandlingExpiry) {
      return;
    }

    _isHandlingExpiry = true;
    try {
      await clearAuthSession(notify: true);
    } finally {
      _isHandlingExpiry = false;
    }
  }
}