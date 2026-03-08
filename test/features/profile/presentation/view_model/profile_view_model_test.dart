import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/profile/presentation/state/profile_state.dart';

void main() {
  group('ProfileState - Simple Tests', () {
    test('ProfileState should have initial status by default', () {
      // arrange & act
      const state = ProfileState();

      // assert
      expect(state.status, ProfileStatus.initial);
    });

    test('ProfileState should have null authEntity by default', () {
      // arrange & act
      const state = ProfileState();

      // assert
      expect(state.authEntity, isNull);
    });

    test('ProfileState should have null successMessage by default', () {
      // arrange & act
      const state = ProfileState();

      // assert
      expect(state.successMessage, isNull);
    });

    test('ProfileState should have null errorMessage by default', () {
      // arrange & act
      const state = ProfileState();

      // assert
      expect(state.errorMessage, isNull);
    });

    test('ProfileState copyWith should update status to loading', () {
      // arrange
      const state = ProfileState();

      // act
      final updated = state.copyWith(status: ProfileStatus.loading);

      // assert
      expect(updated.status, ProfileStatus.loading);
    });

    test('ProfileState copyWith should update status to success', () {
      // arrange
      const state = ProfileState();

      // act
      final updated = state.copyWith(
        status: ProfileStatus.success,
        successMessage: 'Profile updated successfully',
      );

      // assert
      expect(updated.status, ProfileStatus.success);
      expect(updated.successMessage, 'Profile updated successfully');
    });

    test('ProfileState copyWith should update errorMessage on error', () {
      // arrange
      const state = ProfileState();

      // act
      final updated = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Update failed',
      );

      // assert
      expect(updated.status, ProfileStatus.error);
      expect(updated.errorMessage, 'Update failed');
    });

    test('ProfileState copyWith should preserve unmodified fields', () {
      // arrange
      const state = ProfileState(successMessage: 'existing success');

      // act
      final updated = state.copyWith(status: ProfileStatus.loading);

      // assert
      expect(updated.status, ProfileStatus.loading);
      expect(updated.successMessage, 'existing success');
    });

    test('ProfileState with same values should be equal', () {
      // arrange
      const state1 = ProfileState(status: ProfileStatus.initial);
      const state2 = ProfileState(status: ProfileStatus.initial);

      // assert
      expect(state1 == state2, true);
    });

    test('ProfileState with different status should not be equal', () {
      // arrange
      const state1 = ProfileState(status: ProfileStatus.loading);
      const state2 = ProfileState(status: ProfileStatus.error);

      // assert
      expect(state1 == state2, false);
    });

    test('ProfileState should have correct props length', () {
      // arrange
      const state = ProfileState();

      // assert
      expect(state.props.length, 4);
    });

    test('ProfileStatus should contain all expected values', () {
      // assert
      expect(ProfileStatus.values, contains(ProfileStatus.initial));
      expect(ProfileStatus.values, contains(ProfileStatus.loading));
      expect(ProfileStatus.values, contains(ProfileStatus.success));
      expect(ProfileStatus.values, contains(ProfileStatus.error));
    });
  });
}
