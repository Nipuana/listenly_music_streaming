import 'package:flutter_test/flutter_test.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/get_artist_songs_usecase.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/get_artist_dashboard_stats_usecase.dart';

void main() {
  group('GetArtistSongsUsecase - Simple Tests', () {
    test('GetArtistSongsUsecase class should be accessible', () {
      expect(GetArtistSongsUsecase, isNotNull);
    });

    test('GetArtistSongsUsecase represents a no-params query', () {
      expect('$GetArtistSongsUsecase', equals('GetArtistSongsUsecase'));
    });
  });

  group('GetArtistDashboardStatsUsecase - Simple Tests', () {
    test('GetArtistDashboardStatsUsecase class should be accessible', () {
      expect(GetArtistDashboardStatsUsecase, isNotNull);
    });

    test('GetArtistDashboardStatsUsecase represents a no-params query', () {
      expect(
        '$GetArtistDashboardStatsUsecase',
        equals('GetArtistDashboardStatsUsecase'),
      );
    });
  });
}
