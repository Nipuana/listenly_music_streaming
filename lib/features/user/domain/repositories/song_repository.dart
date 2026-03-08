import 'package:dartz/dartz.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

abstract interface class ISongRepository {
  Future<Either<Failure, List<SongEntity>>> getAllSongs();
  Future<Either<Failure, List<SongEntity>>> getMySongs();
  Future<Either<Failure, List<SongEntity>>> getLikedSongs();
  Future<Either<Failure, List<SongEntity>>> getSongsByGenre(String genre);
  Future<Either<Failure, SongEntity>> getSongById(String id);
  Future<Either<Failure, bool>> toggleLike(String songId);
  Future<Either<Failure, bool>> checkIfLiked(String songId);
}
