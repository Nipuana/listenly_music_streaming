import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/constants/hive_table_constant.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/features/user/data/datasources/local/playlist_local_datasource.dart';
import 'package:weplay_music_streaming/features/user/data/datasources/remote/playlist_remote_datasource.dart';
import 'package:weplay_music_streaming/features/user/data/models/playlist_api_model.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/repositories/playlist_repository.dart';

final playlistRepositoryProvider = Provider<IPlaylistRepository>((ref) {
  return PlaylistRepositoryImpl(
    playlistRemoteDatasource: ref.watch(playlistRemoteDataSourceProvider),
    playlistLocalDatasource: ref.watch(playlistLocalDatasourceProvider),
  );
});

class PlaylistRepositoryImpl implements IPlaylistRepository {
  final IPlaylistRemoteDatasource _playlistRemoteDatasource;
  final PlaylistLocalDatasource _playlistLocalDatasource;

  PlaylistRepositoryImpl({
    required IPlaylistRemoteDatasource playlistRemoteDatasource,
    required PlaylistLocalDatasource playlistLocalDatasource,
  })  : _playlistRemoteDatasource = playlistRemoteDatasource,
        _playlistLocalDatasource = playlistLocalDatasource;

  // ─── Typed cache-first helper ──────────────────────────────────────────────

  Future<Either<Failure, List<PlaylistEntity>>> _fetchPlaylists(
    String collectionKey,
    Future<List<PlaylistApiModel>> Function() remoteFetch,
    String errorMessage,
  ) async {
    // 1. Fresh cache
    final cached = _playlistLocalDatasource.getCachedPlaylists(collectionKey);
    if (cached != null && cached.isNotEmpty) {
      return Right(cached.map((m) => m.toEntity()).toList());
    }

    // 2. API fetch + write-through
    try {
      final playlists = await remoteFetch();
      await _playlistLocalDatasource.cachePlaylists(collectionKey, playlists);
      return Right(playlists.map((p) => p.toEntity()).toList());
    } on DioException catch (e) {
      // 3. Stale cache fallback (offline / server error)
      final stale = _playlistLocalDatasource.getStaleCachedPlaylists(collectionKey);
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

  // ─── Read operations (cache-first) ────────────────────────────────────────

  @override
  Future<Either<Failure, List<PlaylistEntity>>> getAllPlaylists() async {
    return _fetchPlaylists(
      HiveTableConstant.allPlaylistsKey,
      () => _playlistRemoteDatasource.getAllPlaylists(),
      'Failed to get all playlists',
    );
  }

  @override
  Future<Either<Failure, List<PlaylistEntity>>> getMyPlaylists() async {
    return _fetchPlaylists(
      HiveTableConstant.myPlaylistsKey,
      () => _playlistRemoteDatasource.getMyPlaylists(),
      'Failed to get my playlists',
    );
  }

  @override
  Future<Either<Failure, List<PlaylistEntity>>> getFavoritedPlaylists() async {
    return _fetchPlaylists(
      HiveTableConstant.favoritedPlaylistsKey,
      () => _playlistRemoteDatasource.getFavoritedPlaylists(),
      'Failed to get favorited playlists',
    );
  }

  @override
  Future<Either<Failure, PlaylistEntity>> getPlaylistById(String id) async {
    final collectionKey = HiveTableConstant.playlistDetailKey(id);

    // 1. Fresh cache for individual playlist
    final cached = _playlistLocalDatasource.getCachedPlaylists(collectionKey);
    if (cached != null && cached.isNotEmpty) {
      return Right(cached.first.toEntity());
    }

    // 2. Fetch from API + write-through
    try {
      final playlist = await _playlistRemoteDatasource.getPlaylistById(id);
      await _playlistLocalDatasource.cachePlaylists(collectionKey, [playlist]);
      return Right(playlist.toEntity());
    } on DioException catch (e) {
      // 3. Stale fallback
      final stale = _playlistLocalDatasource.getStaleCachedPlaylists(collectionKey);
      if (stale != null && stale.isNotEmpty) {
        return Right(stale.first.toEntity());
      }
      return Left(ApiFailure(
          message: e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to get playlist by id'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ─── Mutation operations (invalidate affected caches on success) ───────────

  @override
  Future<Either<Failure, PlaylistEntity>> createPlaylist({
    required String name,
    String? description,
    String? visibility,
    File? coverImage,
  }) async {
    try {
      final playlist = await _playlistRemoteDatasource.createPlaylist(
        name: name,
        description: description,
        visibility: visibility,
        coverImage: coverImage,
      );
      // Invalidate list caches so they refetch to include the new playlist
      await Future.wait([
        _playlistLocalDatasource.invalidate(HiveTableConstant.allPlaylistsKey),
        _playlistLocalDatasource.invalidate(HiveTableConstant.myPlaylistsKey),
      ]);
      return Right(playlist.toEntity());
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to create playlist'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String playlistId) async {
    try {
      final result = await _playlistRemoteDatasource.toggleFavorite(playlistId);
      if (result) {
        // Favorited list and the individual playlist detail are now stale
        await Future.wait([
          _playlistLocalDatasource.invalidate(HiveTableConstant.favoritedPlaylistsKey),
          _playlistLocalDatasource.invalidate(HiveTableConstant.playlistDetailKey(playlistId)),
          _playlistLocalDatasource.invalidate(HiveTableConstant.allPlaylistsKey),
        ]);
      }
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to toggle favorite'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkIfFavorited(String playlistId) async {
    try {
      final result = await _playlistRemoteDatasource.checkIfFavorited(playlistId);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.message ?? 'Failed to check favorite status'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePlaylist(String playlistId) async {
    try {
      final result = await _playlistRemoteDatasource.deletePlaylist(playlistId);
      if (result) {
        // Remove from all playlist caches
        await Future.wait([
          _playlistLocalDatasource.invalidate(HiveTableConstant.allPlaylistsKey),
          _playlistLocalDatasource.invalidate(HiveTableConstant.myPlaylistsKey),
          _playlistLocalDatasource.invalidate(HiveTableConstant.favoritedPlaylistsKey),
          _playlistLocalDatasource.invalidate(HiveTableConstant.playlistDetailKey(playlistId)),
        ]);
      }
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to delete playlist'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addSongToPlaylist(
      String playlistId, String songId) async {
    try {
      final result =
          await _playlistRemoteDatasource.addSongToPlaylist(playlistId, songId);
      if (result) {
        // Playlist detail is now stale (song count / songs list changed)
        await _playlistLocalDatasource
            .invalidate(HiveTableConstant.playlistDetailKey(playlistId));
      }
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to add song to playlist'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeSongFromPlaylist(
      String playlistId, String songId) async {
    try {
      final result = await _playlistRemoteDatasource.removeSongFromPlaylist(
          playlistId, songId);
      if (result) {
        await _playlistLocalDatasource
            .invalidate(HiveTableConstant.playlistDetailKey(playlistId));
      }
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to remove song from playlist'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
