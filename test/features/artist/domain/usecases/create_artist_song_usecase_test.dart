import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/create_artist_song_usecase.dart';

void main() {
  group('CreateArtistSongParams - Simple Tests', () {
    test('CreateArtistSongParams should be created with required fields', () {
      // arrange & act
      const params = CreateArtistSongParams(
        title: 'My Song',
        genre: 'Pop',
        audioFilePath: '/path/to/audio.mp3',
      );

      // assert
      expect(params.title, 'My Song');
      expect(params.genre, 'Pop');
      expect(params.audioFilePath, '/path/to/audio.mp3');
    });

    test('CreateArtistSongParams should have default visibility as public', () {
      // arrange
      const params = CreateArtistSongParams(
        title: 'My Song',
        genre: 'Rock',
        audioFilePath: '/path/to/audio.mp3',
      );

      // assert
      expect(params.visibility, 'public');
    });

    test('CreateArtistSongParams with same values should be equal', () {
      // arrange
      const params1 = CreateArtistSongParams(
        title: 'My Song',
        genre: 'Pop',
        audioFilePath: '/audio.mp3',
      );
      const params2 = CreateArtistSongParams(
        title: 'My Song',
        genre: 'Pop',
        audioFilePath: '/audio.mp3',
      );

      // assert
      expect(params1 == params2, true);
    });

    test('CreateArtistSongParams with different title should not be equal', () {
      // arrange
      const params1 = CreateArtistSongParams(
        title: 'Song A',
        genre: 'Pop',
        audioFilePath: '/audio.mp3',
      );
      const params2 = CreateArtistSongParams(
        title: 'Song B',
        genre: 'Pop',
        audioFilePath: '/audio.mp3',
      );

      // assert
      expect(params1 == params2, false);
    });

    test('CreateArtistSongParams should have correct props count', () {
      // arrange
      const params = CreateArtistSongParams(
        title: 'My Song',
        genre: 'Pop',
        audioFilePath: '/path/to/audio.mp3',
        coverImagePath: '/path/to/cover.jpg',
      );

      // assert
      expect(params.props.length, 5);
    });

    test('CreateArtistSongParams coverImagePath defaults to null', () {
      // arrange
      const params = CreateArtistSongParams(
        title: 'My Song',
        genre: 'Pop',
        audioFilePath: '/audio.mp3',
      );

      // assert
      expect(params.coverImagePath, isNull);
    });
  });
}
