import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/user/data/repositories/playlist_repository_impl.dart';
import 'package:weplay_music_streaming/features/user/domain/repositories/playlist_repository.dart';

final deletePlaylistUsecaseProvider = Provider<DeletePlaylistUsecase>((ref) {
  return DeletePlaylistUsecase(
    playlistRepository: ref.read(playlistRepositoryProvider),
  );
});

class DeletePlaylistUsecase implements UsecaseWithParms<bool, String> {
  final IPlaylistRepository _playlistRepository;

  DeletePlaylistUsecase({required IPlaylistRepository playlistRepository})
      : _playlistRepository = playlistRepository;

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _playlistRepository.deletePlaylist(params);
  }
}