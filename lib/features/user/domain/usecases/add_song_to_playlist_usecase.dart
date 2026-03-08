import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/user/data/repositories/playlist_repository_impl.dart';
import 'package:weplay_music_streaming/features/user/domain/repositories/playlist_repository.dart';

class AddSongToPlaylistParams extends Equatable {
  final String playlistId;
  final String songId;

  const AddSongToPlaylistParams({
    required this.playlistId,
    required this.songId,
  });

  @override
  List<Object?> get props => [playlistId, songId];
}

final addSongToPlaylistUsecaseProvider = Provider<AddSongToPlaylistUsecase>((ref) {
  return AddSongToPlaylistUsecase(playlistRepository: ref.read(playlistRepositoryProvider));
});

class AddSongToPlaylistUsecase implements UsecaseWithParms<bool, AddSongToPlaylistParams> {
  final IPlaylistRepository _playlistRepository;

  AddSongToPlaylistUsecase({required IPlaylistRepository playlistRepository})
      : _playlistRepository = playlistRepository;

  @override
  Future<Either<Failure, bool>> call(AddSongToPlaylistParams params) {
    return _playlistRepository.addSongToPlaylist(params.playlistId, params.songId);
  }
}
