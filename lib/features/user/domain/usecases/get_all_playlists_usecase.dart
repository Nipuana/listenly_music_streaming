import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/user/data/repositories/playlist_repository_impl.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/repositories/playlist_repository.dart';

final getAllPlaylistsUsecaseProvider = Provider<GetAllPlaylistsUsecase>((ref) {
  return GetAllPlaylistsUsecase(playlistRepository: ref.read(playlistRepositoryProvider));
});

class GetAllPlaylistsUsecase implements UsecaseWithoutParms<List<PlaylistEntity>> {
  final IPlaylistRepository _playlistRepository;

  GetAllPlaylistsUsecase({required IPlaylistRepository playlistRepository})
      : _playlistRepository = playlistRepository;

  @override
  Future<Either<Failure, List<PlaylistEntity>>> call() {
    return _playlistRepository.getAllPlaylists();
  }
}
