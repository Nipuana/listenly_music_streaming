import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/auth/presentation/state/auth_state.dart';

void main() {
  group('AuthState - Simple Tests', () {
    test('AuthState should have initial status by default', () {
      // arrange & act
      const state = AuthState();

      // assert
      expect(state.status, AuthStatus.initial);
    });

    test('AuthState should have null authEntity by default', () {
      // arrange & act
      const state = AuthState();

      // assert
      expect(state.authEntity, isNull);
    });

    test('AuthState should have null errorMessage by default', () {
      // arrange & act
      const state = AuthState();

      // assert
      expect(state.errorMessage, isNull);
    });

    test('AuthState copyWith should update status', () {
      // arrange
      const state = AuthState();

      // act
      final updated = state.copyWith(status: AuthStatus.loading);

      // assert
      expect(updated.status, AuthStatus.loading);
      expect(updated.authEntity, isNull);
      expect(updated.errorMessage, isNull);
    });

    test('AuthState copyWith should update errorMessage', () {
      // arrange
      const state = AuthState();

      // act
      final updated = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid credentials',
      );

      // assert
      expect(updated.status, AuthStatus.error);
      expect(updated.errorMessage, 'Invalid credentials');
    });

    test('AuthState copyWith should preserve unmodified fields', () {
      // arrange
      const state = AuthState(errorMessage: 'existing error');

      // act
      final updated = state.copyWith(status: AuthStatus.loading);

      // assert
      expect(updated.status, AuthStatus.loading);
      expect(updated.errorMessage, 'existing error');
    });

    test('AuthState with same values should be equal', () {
      // arrange
      const state1 = AuthState(status: AuthStatus.initial);
      const state2 = AuthState(status: AuthStatus.initial);

      // assert
      expect(state1 == state2, true);
    });

    test('AuthState with different status should not be equal', () {
      // arrange
      const state1 = AuthState(status: AuthStatus.loading);
      const state2 = AuthState(status: AuthStatus.error);

      // assert
      expect(state1 == state2, false);
    });

    test('AuthState should have correct props length', () {
      // arrange
      const state = AuthState();

      // assert
      expect(state.props.length, 3);
    });

    test('AuthStatus should contain all expected values', () {
      // assert
      expect(AuthStatus.values, contains(AuthStatus.initial));
      expect(AuthStatus.values, contains(AuthStatus.loading));
      expect(AuthStatus.values, contains(AuthStatus.authenticated));
      expect(AuthStatus.values, contains(AuthStatus.unauthenticated));
      expect(AuthStatus.values, contains(AuthStatus.registered));
      expect(AuthStatus.values, contains(AuthStatus.error));
    });
  });
}
