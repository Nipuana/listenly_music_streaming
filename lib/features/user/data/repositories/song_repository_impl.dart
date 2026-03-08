import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/hive_table_constant.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/features/user/data/datasources/local/song_local_datasource.dart';
import 'package:weplay_music_streaming/features/user/data/datasources/remote/song_remote_datasource.dart';
import 'package:weplay_music_streaming/features/user/data/models/song_api_model.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/repositories/song_repository.dart';

final songRepositoryProvider = Provider<ISongRepository>((ref) {
  return SongRepositoryImpl(
    songRemoteDatasource: ref.watch(songRemoteDataSourceProvider),
    songLocalDatasource: ref.watch(songLocalDatasourceProvider),
  );
});

class SongRepositoryImpl implements ISongRepository {
  final ISongRemoteDatasource _songRemoteDatasource;
  final SongLocalDatasource _songLocalDatasource;

  SongRepositoryImpl({
    required ISongRemoteDatasource songRemoteDatasource,
    required SongLocalDatasource songLocalDatasource,
  })  : _songRemoteDatasource = songRemoteDatasource,
        _songLocalDatasource = songLocalDatasource;

  // ─── Read operations (cache-first) ────────────────────────────────────────

  @override
  Future<Either<Failure, List<SongEntity>>> getAllSongs() async {
    return _fetchSongsTyped(
      HiveTableConstant.allSongsKey,
      () => _songRemoteDatasource.getAllSongs(),
      'Failed to get all songs',
    );
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getMySongs() async {
    return _fetchSongsTyped(
      HiveTableConstant.mySongsKey,
      () => _songRemoteDatasource.getMySongs(),
      'Failed to get my songs',
    );
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getLikedSongs() async {
    return _fetchSongsTyped(
      HiveTableConstant.likedSongsKey,
      () => _songRemoteDatasource.getLikedSongs(),
      'Failed to get liked songs',
    );
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getSongsByGenre(String genre) async {
    // Genre collections are not cached separately — derive from the all-songs cache
    // to avoid unbounded cache growth (one entry per genre × many genres).
    final allCached = _songLocalDatasource.getCachedSongs(HiveTableConstant.allSongsKey);
    if (allCached != null && allCached.isNotEmpty) {
      final filtered = allCached
          .where((m) => m.genre.toLowerCase() == genre.toLowerCase())
          .map((m) => m.toEntity())
          .toList();
      if (filtered.isNotEmpty) return Right(filtered);
    }

    try {
      final songs = await _songRemoteDatasource.getSongsByGenre(genre);
      return Right(songs.map((s) => s.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to get songs by genre'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SongEntity>> getSongById(String id) async {
    try {
      final song = await _songRemoteDatasource.getSongById(id);
      return Right(song.toEntity());
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to get song by id'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ─── Mutation operations (invalidate affected caches on success) ───────────

  @override
  Future<Either<Failure, bool>> toggleLike(String songId) async {
    try {
      final result = await _songRemoteDatasource.toggleLike(songId);
      if (result) {
        // Like status changed — liked-songs list and all-songs list are now stale
        await Future.wait([
          _songLocalDatasource.invalidate(HiveTableConstant.likedSongsKey),
          _songLocalDatasource.invalidate(HiveTableConstant.allSongsKey),
        ]);
      }
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to toggle like'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkIfLiked(String songId) async {
    try {
      final result = await _songRemoteDatasource.checkIfLiked(songId);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.message ?? 'Failed to check like status'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ─── Typed helper (avoids cast gymnastics in each method) ─────────────────

  Future<Either<Failure, List<SongEntity>>> _fetchSongsTyped(
    String collectionKey,
    Future<List<SongApiModel>> Function() remoteFetch,
    String errorMessage,
  ) async {
    // 1. Fresh cache
    final cached = _songLocalDatasource.getCachedSongs(collectionKey);
    if (cached != null && cached.isNotEmpty) {
      return Right(cached.map((m) => m.toEntity()).toList());
    }

    // 2. API fetch + write-through
    try {
      final songs = await remoteFetch();
      await _songLocalDatasource.cacheSongs(collectionKey, songs);
      return Right(songs.map((s) => s.toEntity()).toList());
    } on DioException catch (e) {
      // 3. Stale cache fallback (offline / server error)
      final stale = _songLocalDatasource.getStaleCachedSongs(collectionKey);
      if (stale != null && stale.isNotEmpty) {
        return Right(stale.map((m) => m.toEntity()).toList());
      }
      return Left(ApiFailure(
          message: e.response?.data?['message'] as String? ??
              e.message ??
              errorMessage));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
