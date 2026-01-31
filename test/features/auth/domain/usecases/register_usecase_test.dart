import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/register_usecase.dart';

void main() {
  group('RegisterUsecase ', () {
    test('RegisterUsecaseParams should be created with all required fields', () {
      // arrange
      const username = 'testuser';
      const email = 'test@example.com';
      const password = 'password123';
      const confirmPassword = 'password123';

      
      const params = RegisterUsecaseParams(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

    
      expect(params.username, username);
      expect(params.email, email);
      expect(params.password, password);
      expect(params.confirmPassword, confirmPassword);
    });

    test('RegisterUsecaseParams with same values should be equal', () {
      
      const params1 = RegisterUsecaseParams(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );
      const params2 = RegisterUsecaseParams(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );

      // assert
      expect(params1 == params2, true);
    });

    test('RegisterUsecaseParams with different values should not be equal', () {
      // arrange
      const params1 = RegisterUsecaseParams(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );
      const params2 = RegisterUsecaseParams(
        username: 'differentuser',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );

    
      expect(params1 == params2, false);
    });

    test('RegisterUsecaseParams should handle optional userType', () {
      
      const paramsWithoutType = RegisterUsecaseParams(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );

      const paramsWithType = RegisterUsecaseParams(
        username: 'testuser',
        email: 'test@example.com',
        userType: 'Premium',
        password: 'password123',
        confirmPassword: 'password123',
      );

      // assert
      expect(paramsWithoutType.userType, null);
      expect(paramsWithType.userType, 'Premium');
    });

    test('RegisterUsecaseParams should have correct props count', () {
      // arrange
      const params = RegisterUsecaseParams(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );

      // assert
      expect(params.props.length, 5);
    });
  });
}
