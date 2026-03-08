import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/delete_artist_song_usecase.dart';

void main() {
  group('DeleteArtistSongParams - Simple Tests', () {
    test('DeleteArtistSongParams should be created with songId', () {
      // arrange
      const songId = 'song_artist_123';

      // act
      const params = DeleteArtistSongParams(songId: songId);

      // assert
      expect(params.songId, songId);
    });

    test('DeleteArtistSongParams with same values should be equal', () {
      // arrange
      const params1 = DeleteArtistSongParams(songId: 'song_abc');
      const params2 = DeleteArtistSongParams(songId: 'song_abc');

      // assert
      expect(params1 == params2, true);
    });

    test('DeleteArtistSongParams with different values should not be equal', () {
      // arrange
      const params1 = DeleteArtistSongParams(songId: 'song_111');
      const params2 = DeleteArtistSongParams(songId: 'song_222');

      // assert
      expect(params1 == params2, false);
    });

    test('DeleteArtistSongParams should have correct props', () {
      // arrange
      const params = DeleteArtistSongParams(songId: 'song_artist_123');

      // assert
      expect(params.props.length, 1);
      expect(params.props.contains('song_artist_123'), true);
    });
  });
}