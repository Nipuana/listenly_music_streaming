import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/features/artist/data/datasources/remote/artist_remote_datasource.dart';
import 'package:weplay_music_streaming/features/artist/domain/entities/artist_stats_entity.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/delete_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/artist/domain/repositories/artist_repository.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/create_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/update_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

final artistRepositoryProvider = Provider<IArtistRepository>((ref) {
  return ArtistRepositoryImpl(
    artistRemoteDatasource: ref.watch(artistRemoteDataSourceProvider),
  );
});

class ArtistRepositoryImpl implements IArtistRepository {
  final IArtistRemoteDatasource _artistRemoteDatasource;

  ArtistRepositoryImpl({required IArtistRemoteDatasource artistRemoteDatasource})
      : _artistRemoteDatasource = artistRemoteDatasource;

  @override
  Future<Either<Failure, ArtistStatsEntity>> getDashboardStats() async {
    try {
      final stats = await _artistRemoteDatasource.getDashboardStats();
      return Right(stats.toEntity());
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.message ?? 'Failed to get artist dashboard stats'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getArtistSongs() async {
    try {
      final songs = await _artistRemoteDatasource.getArtistSongs();
      final entities = songs.map((song) => song.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.message ?? 'Failed to get artist songs'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SongEntity>> getArtistSongDetails(String songId) async {
    try {
      final song = await _artistRemoteDatasource.getArtistSongDetails(songId);
      return Right(song.toEntity());
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.message ?? 'Failed to get artist song details'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SongEntity>> createArtistSong(CreateArtistSongParams params) async {
    try {
      final song = await _artistRemoteDatasource.createArtistSong(params);
      return Right(song.toEntity());
    } on DioException catch (e) {
      final responseMessage = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message'] as String?)
          : null;
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: responseMessage ?? e.message ?? 'Failed to create song',
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SongEntity>> updateArtistSong(UpdateArtistSongParams params) async {
    try {
      final song = await _artistRemoteDatasource.updateArtistSong(params);
      return Right(song.toEntity());
    } on DioException catch (e) {
      final responseMessage = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message'] as String?)
          : null;
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: responseMessage ?? e.message ?? 'Failed to update song',
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteArtistSong(DeleteArtistSongParams params) async {
    try {
      final deleted = await _artistRemoteDatasource.deleteArtistSong(params);
      return Right(deleted);
    } on DioException catch (e) {
      final responseMessage = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message'] as String?)
          : null;
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: responseMessage ?? e.message ?? 'Failed to delete song',
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
