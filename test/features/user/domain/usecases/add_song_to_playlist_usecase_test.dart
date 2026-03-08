import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/add_song_to_playlist_usecase.dart';

void main() {
  group('AddSongToPlaylistParams - Simple Tests', () {
    test('AddSongToPlaylistParams should be created with playlistId and songId', () {
      // arrange
      const playlistId = 'playlist_123';
      const songId = 'song_456';

      // act
      const params = AddSongToPlaylistParams(
        playlistId: playlistId,
        songId: songId,
      );

      // assert
      expect(params.playlistId, playlistId);
      expect(params.songId, songId);
    });

    test('AddSongToPlaylistParams with same values should be equal', () {
      // arrange
      const params1 = AddSongToPlaylistParams(
        playlistId: 'playlist_abc',
        songId: 'song_def',
      );
      const params2 = AddSongToPlaylistParams(
        playlistId: 'playlist_abc',
        songId: 'song_def',
      );

      // assert
      expect(params1 == params2, true);
    });

    test('AddSongToPlaylistParams with different songId should not be equal', () {
      // arrange
      const params1 = AddSongToPlaylistParams(
        playlistId: 'playlist_abc',
        songId: 'song_111',
      );
      const params2 = AddSongToPlaylistParams(
        playlistId: 'playlist_abc',
        songId: 'song_222',
      );

      // assert
      expect(params1 == params2, false);
    });

    test('AddSongToPlaylistParams should have correct props', () {
      // arrange
      const params = AddSongToPlaylistParams(
        playlistId: 'playlist_123',
        songId: 'song_456',
      );

      // assert
      expect(params.props.length, 2);
      expect(params.props.contains('playlist_123'), true);
      expect(params.props.contains('song_456'), true);
    });
  });
}
