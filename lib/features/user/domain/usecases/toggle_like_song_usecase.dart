import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/user/data/repositories/song_repository_impl.dart';
import 'package:weplay_music_streaming/features/user/domain/repositories/song_repository.dart';

class ToggleLikeParams extends Equatable {
  final String songId;

  const ToggleLikeParams({required this.songId});

  @override
  List<Object?> get props => [songId];
}

final toggleLikeSongUsecaseProvider = Provider<ToggleLikeSongUsecase>((ref) {
  return ToggleLikeSongUsecase(songRepository: ref.read(songRepositoryProvider));
});

class ToggleLikeSongUsecase implements UsecaseWithParms<bool, ToggleLikeParams> {
  final ISongRepository _songRepository;

  ToggleLikeSongUsecase({required ISongRepository songRepository})
      : _songRepository = songRepository;

  @override
  Future<Either<Failure, bool>> call(ToggleLikeParams params) {
    return _songRepository.toggleLike(params.songId);
  }
}
