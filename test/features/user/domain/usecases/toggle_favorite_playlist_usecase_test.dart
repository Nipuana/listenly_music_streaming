import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/toggle_favorite_playlist_usecase.dart';

void main() {
  group('ToggleFavoriteParams - Simple Tests', () {
    test('ToggleFavoriteParams should be created with playlistId', () {
      // arrange
      const playlistId = 'playlist_123';

      // act
      const params = ToggleFavoriteParams(playlistId: playlistId);

      // assert
      expect(params.playlistId, playlistId);
    });

    test('ToggleFavoriteParams with same values should be equal', () {
      // arrange
      const params1 = ToggleFavoriteParams(playlistId: 'playlist_abc');
      const params2 = ToggleFavoriteParams(playlistId: 'playlist_abc');

      // assert
      expect(params1 == params2, true);
    });

    test('ToggleFavoriteParams with different values should not be equal', () {
      // arrange
      const params1 = ToggleFavoriteParams(playlistId: 'playlist_abc');
      const params2 = ToggleFavoriteParams(playlistId: 'playlist_xyz');

      // assert
      expect(params1 == params2, false);
    });

    test('ToggleFavoriteParams should have correct props', () {
      // arrange
      const params = ToggleFavoriteParams(playlistId: 'playlist_123');

      // assert
      expect(params.props.length, 1);
      expect(params.props.contains('playlist_123'), true);
    });
  });
}
