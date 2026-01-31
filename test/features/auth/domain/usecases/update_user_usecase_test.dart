import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/update_user_usecase.dart';

void main() {
  group('UpdateUserUsecase - Simple Tests', () {
    test('UpdateUserParams should be created with all fields', () {
      // arrange & act
      const params = UpdateUserParams(
        username: 'newusername',
        email: 'new@example.com',
        profilePicture: 'https://example.com/pic.jpg',
        filePath: '/path/to/image.jpg',
      );

      // assert
      expect(params.username, 'newusername');
      expect(params.email, 'new@example.com');
      expect(params.profilePicture, 'https://example.com/pic.jpg');
      expect(params.filePath, '/path/to/image.jpg');
    });

    test('UpdateUserParams should allow null values', () {
      // arrange & act
      const params = UpdateUserParams();

      // assert
      expect(params.username, null);
      expect(params.email, null);
      expect(params.profilePicture, null);
      expect(params.filePath, null);
    });

    test('UpdateUserParams should allow partial updates', () {
      // arrange & act
      const paramsUsernameOnly = UpdateUserParams(username: 'newname');
      const paramsEmailOnly = UpdateUserParams(email: 'new@example.com');
      const paramsProfileOnly = UpdateUserParams(profilePicture: 'pic.jpg');

      // assert
      expect(paramsUsernameOnly.username, 'newname');
      expect(paramsUsernameOnly.email, null);

      expect(paramsEmailOnly.username, null);
      expect(paramsEmailOnly.email, 'new@example.com');

      expect(paramsProfileOnly.profilePicture, 'pic.jpg');
      expect(paramsProfileOnly.username, null);
    });

    test('UpdateUserParams with same values should be equal', () {
      // arrange
      const params1 = UpdateUserParams(
        username: 'testuser',
        email: 'test@example.com',
      );
      const params2 = UpdateUserParams(
        username: 'testuser',
        email: 'test@example.com',
      );

      // assert
      expect(params1 == params2, true);
    });

    test('UpdateUserParams with different values should not be equal', () {
      // arrange
      const params1 = UpdateUserParams(username: 'user1');
      const params2 = UpdateUserParams(username: 'user2');

      // assert
      expect(params1 == params2, false);
    });

    test('UpdateUserParams should have correct props count', () {
      // arrange
      const params = UpdateUserParams(
        username: 'test',
        email: 'test@example.com',
      );

      // assert
      expect(params.props.length, 4);
    });
  });
}
