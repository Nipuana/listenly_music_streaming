import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/login_usecase.dart';

void main() {
  group('LoginUsecase - Simple Tests', () {
    test('LoginUsecaseParams should be created with email and password', () {
      // arrange
      const email = 'test@example.com';
      const password = 'password123';

      // act
      const params = LoginUsecaseParams(email: email, password: password);

      // assert
      expect(params.email, email);
      expect(params.password, password);
    });

    test('LoginUsecaseParams with same values should be equal', () {
      // arrange
      const params1 = LoginUsecaseParams(email: 'test@example.com', password: 'password123');
      const params2 = LoginUsecaseParams(email: 'test@example.com', password: 'password123');

      // assert
      expect(params1 == params2, true);
    });

    test('LoginUsecaseParams with different values should not be equal', () {
      // arrange
      const params1 = LoginUsecaseParams(email: 'test@example.com', password: 'password123');
      const params2 = LoginUsecaseParams(email: 'other@example.com', password: 'password123');

      // assert
      expect(params1 == params2, false);
    });

    test('LoginUsecaseParams should have correct props', () {
      // arrange
      const params = LoginUsecaseParams(email: 'test@example.com', password: 'password123');

      // assert
      expect(params.props.length, 2);
      expect(params.props.contains('test@example.com'), true);
      expect(params.props.contains('password123'), true);
    });
  });
}
