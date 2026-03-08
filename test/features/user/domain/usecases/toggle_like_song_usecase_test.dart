import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/toggle_like_song_usecase.dart';

void main() {
  group('ToggleLikeParams - Simple Tests', () {
    test('ToggleLikeParams should be created with songId', () {
      // arrange
      const songId = 'song_123';

      // act
      const params = ToggleLikeParams(songId: songId);

      // assert
      expect(params.songId, songId);
    });

    test('ToggleLikeParams with same values should be equal', () {
      // arrange
      const params1 = ToggleLikeParams(songId: 'song_abc');
      const params2 = ToggleLikeParams(songId: 'song_abc');

      // assert
      expect(params1 == params2, true);
    });

    test('ToggleLikeParams with different values should not be equal', () {
      // arrange
      const params1 = ToggleLikeParams(songId: 'song_abc');
      const params2 = ToggleLikeParams(songId: 'song_xyz');

      // assert
      expect(params1 == params2, false);
    });

    test('ToggleLikeParams should have correct props', () {
      // arrange
      const params = ToggleLikeParams(songId: 'song_123');

      // assert
      expect(params.props.length, 1);
      expect(params.props.contains('song_123'), true);
    });
  });
}
