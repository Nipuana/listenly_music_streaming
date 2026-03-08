import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/reset_password_usecase.dart';

void main() {
  group('ResetPasswordParams - Simple Tests', () {
    test('ResetPasswordParams should be created with token and newPassword', () {
      // arrange
      const token = 'reset_token_abc123';
      const newPassword = 'newSecurePass!1';

      // act
      const params = ResetPasswordParams(token: token, newPassword: newPassword);

      // assert
      expect(params.token, token);
      expect(params.newPassword, newPassword);
    });

    test('ResetPasswordParams with same values should be equal', () {
      // arrange
      const params1 = ResetPasswordParams(
        token: 'token_xyz',
        newPassword: 'pass123',
      );
      const params2 = ResetPasswordParams(
        token: 'token_xyz',
        newPassword: 'pass123',
      );

      // assert
      expect(params1 == params2, true);
    });

    test('ResetPasswordParams with different token should not be equal', () {
      // arrange
      const params1 = ResetPasswordParams(
        token: 'token_aaa',
        newPassword: 'pass123',
      );
      const params2 = ResetPasswordParams(
        token: 'token_bbb',
        newPassword: 'pass123',
      );

      // assert
      expect(params1 == params2, false);
    });

    test('ResetPasswordParams should have correct props', () {
      // arrange
      const params = ResetPasswordParams(
        token: 'reset_token_abc123',
        newPassword: 'newSecurePass!1',
      );

      // assert
      expect(params.props.length, 2);
      expect(params.props.contains('reset_token_abc123'), true);
      expect(params.props.contains('newSecurePass!1'), true);
    });
  });
}
