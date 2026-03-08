import 'package:dartz/dartz.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/features/artist/domain/entities/artist_stats_entity.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/delete_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/create_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/update_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

abstract interface class IArtistRepository {
  Future<Either<Failure, ArtistStatsEntity>> getDashboardStats();
  Future<Either<Failure, List<SongEntity>>> getArtistSongs();
  Future<Either<Failure, SongEntity>> getArtistSongDetails(String songId);
  Future<Either<Failure, SongEntity>> createArtistSong(CreateArtistSongParams params);
  Future<Either<Failure, SongEntity>> updateArtistSong(UpdateArtistSongParams params);
  Future<Either<Failure, bool>> deleteArtistSong(DeleteArtistSongParams params);
}
