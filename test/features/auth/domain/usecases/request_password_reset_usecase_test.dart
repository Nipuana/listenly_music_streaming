import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/request_password_reset_usecase.dart';

void main() {
  group('RequestPasswordResetParams - Simple Tests', () {
    test('RequestPasswordResetParams should be created with email', () {
      // arrange
      const email = 'user@example.com';

      // act
      const params = RequestPasswordResetParams(email: email);

      // assert
      expect(params.email, email);
    });

    test('RequestPasswordResetParams with same values should be equal', () {
      // arrange
      const params1 = RequestPasswordResetParams(email: 'user@example.com');
      const params2 = RequestPasswordResetParams(email: 'user@example.com');

      // assert
      expect(params1 == params2, true);
    });

    test('RequestPasswordResetParams with different emails should not be equal', () {
      // arrange
      const params1 = RequestPasswordResetParams(email: 'user1@example.com');
      const params2 = RequestPasswordResetParams(email: 'user2@example.com');

      // assert
      expect(params1 == params2, false);
    });

    test('RequestPasswordResetParams should have correct props', () {
      // arrange
      const params = RequestPasswordResetParams(email: 'user@example.com');

      // assert
      expect(params.props.length, 1);
      expect(params.props.contains('user@example.com'), true);
    });
  });
}
