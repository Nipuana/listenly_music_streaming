import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/update_artist_song_usecase.dart';

void main() {
  group('UpdateArtistSongParams - Simple Tests', () {
    test('UpdateArtistSongParams should be created with all required fields', () {
      // arrange & act
      const params = UpdateArtistSongParams(
        songId: 'song_123',
        title: 'Updated Title',
        genre: 'Jazz',
        visibility: 'public',
      );

      // assert
      expect(params.songId, 'song_123');
      expect(params.title, 'Updated Title');
      expect(params.genre, 'Jazz');
      expect(params.visibility, 'public');
    });

    test('UpdateArtistSongParams with same values should be equal', () {
      // arrange
      const params1 = UpdateArtistSongParams(
        songId: 'song_abc',
        title: 'Title',
        genre: 'Pop',
        visibility: 'public',
      );
      const params2 = UpdateArtistSongParams(
        songId: 'song_abc',
        title: 'Title',
        genre: 'Pop',
        visibility: 'public',
      );

      // assert
      expect(params1 == params2, true);
    });

    test('UpdateArtistSongParams with different songId should not be equal', () {
      // arrange
      const params1 = UpdateArtistSongParams(
        songId: 'song_111',
        title: 'Title',
        genre: 'Pop',
        visibility: 'public',
      );
      const params2 = UpdateArtistSongParams(
        songId: 'song_222',
        title: 'Title',
        genre: 'Pop',
        visibility: 'public',
      );

      // assert
      expect(params1 == params2, false);
    });

    test('UpdateArtistSongParams should have correct props', () {
      // arrange
      const params = UpdateArtistSongParams(
        songId: 'song_123',
        title: 'Updated Title',
        genre: 'Jazz',
        visibility: 'public',
      );

      // assert
      expect(params.props.length, 4);
      expect(params.props.contains('song_123'), true);
      expect(params.props.contains('Updated Title'), true);
      expect(params.props.contains('Jazz'), true);
      expect(params.props.contains('public'), true);
    });
  });
}
