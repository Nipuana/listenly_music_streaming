import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';

abstract interface class IPlaylistRepository {
  Future<Either<Failure, List<PlaylistEntity>>> getAllPlaylists();
  Future<Either<Failure, List<PlaylistEntity>>> getMyPlaylists();
  Future<Either<Failure, List<PlaylistEntity>>> getFavoritedPlaylists();
  Future<Either<Failure, PlaylistEntity>> getPlaylistById(String id);
  Future<Either<Failure, PlaylistEntity>> createPlaylist({
    required String name,
    String? description,
    String? visibility,
    File? coverImage,
  });
  Future<Either<Failure, bool>> toggleFavorite(String playlistId);
  Future<Either<Failure, bool>> checkIfFavorited(String playlistId);
  Future<Either<Failure, bool>> deletePlaylist(String playlistId);
  Future<Either<Failure, bool>> addSongToPlaylist(String playlistId, String songId);
  Future<Either<Failure, bool>> removeSongFromPlaylist(String playlistId, String songId);
}
