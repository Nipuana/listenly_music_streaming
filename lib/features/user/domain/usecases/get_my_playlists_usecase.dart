import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/user/data/repositories/playlist_repository_impl.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/repositories/playlist_repository.dart';

final getMyPlaylistsUsecaseProvider = Provider<GetMyPlaylistsUsecase>((ref) {
  return GetMyPlaylistsUsecase(playlistRepository: ref.read(playlistRepositoryProvider));
});

class GetMyPlaylistsUsecase implements UsecaseWithoutParms<List<PlaylistEntity>> {
  final IPlaylistRepository _playlistRepository;

  GetMyPlaylistsUsecase({required IPlaylistRepository playlistRepository})
      : _playlistRepository = playlistRepository;

  @override
  Future<Either<Failure, List<PlaylistEntity>>> call() {
    return _playlistRepository.getMyPlaylists();
  }
}
