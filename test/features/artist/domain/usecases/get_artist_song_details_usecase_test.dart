import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/get_artist_song_details_usecase.dart';

void main() {
  group('GetArtistSongDetailsParams - Simple Tests', () {
    test('GetArtistSongDetailsParams should be created with songId', () {
      // arrange
      const songId = 'song_detail_123';

      // act
      const params = GetArtistSongDetailsParams(songId: songId);

      // assert
      expect(params.songId, songId);
    });

    test('GetArtistSongDetailsParams with same values should be equal', () {
      // arrange
      const params1 = GetArtistSongDetailsParams(songId: 'song_abc');
      const params2 = GetArtistSongDetailsParams(songId: 'song_abc');

      // assert
      expect(params1 == params2, true);
    });

    test('GetArtistSongDetailsParams with different values should not be equal', () {
      // arrange
      const params1 = GetArtistSongDetailsParams(songId: 'song_aaa');
      const params2 = GetArtistSongDetailsParams(songId: 'song_bbb');

      // assert
      expect(params1 == params2, false);
    });

    test('GetArtistSongDetailsParams should have correct props', () {
      // arrange
      const params = GetArtistSongDetailsParams(songId: 'song_detail_123');

      // assert
      expect(params.props.length, 1);
      expect(params.props.contains('song_detail_123'), true);
    });
  });

  group('GetArtistSongsUsecase - Simple Tests', () {
    test('GetArtistSongsUsecase class should be accessible', () {
      expect(GetArtistSongDetailsUsecase, isNotNull);
    });
  });
}
