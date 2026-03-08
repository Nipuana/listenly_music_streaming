import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/user/data/repositories/playlist_repository_impl.dart';
import 'package:weplay_music_streaming/features/user/domain/repositories/playlist_repository.dart';

class ToggleFavoriteParams extends Equatable {
  final String playlistId;

  const ToggleFavoriteParams({required this.playlistId});

  @override
  List<Object?> get props => [playlistId];
}

final toggleFavoritePlaylistUsecaseProvider = Provider<ToggleFavoritePlaylistUsecase>((ref) {
  return ToggleFavoritePlaylistUsecase(playlistRepository: ref.read(playlistRepositoryProvider));
});

class ToggleFavoritePlaylistUsecase implements UsecaseWithParms<bool, ToggleFavoriteParams> {
  final IPlaylistRepository _playlistRepository;

  ToggleFavoritePlaylistUsecase({required IPlaylistRepository playlistRepository})
      : _playlistRepository = playlistRepository;

  @override
  Future<Either<Failure, bool>> call(ToggleFavoriteParams params) {
    return _playlistRepository.toggleFavorite(params.playlistId);
  }
}
