import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/user/data/repositories/song_repository_impl.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/repositories/song_repository.dart';

final getMySongsUsecaseProvider = Provider<GetMySongsUsecase>((ref) {
  return GetMySongsUsecase(songRepository: ref.read(songRepositoryProvider));
});

class GetMySongsUsecase implements UsecaseWithoutParms<List<SongEntity>> {
  final ISongRepository _songRepository;

  GetMySongsUsecase({required ISongRepository songRepository})
      : _songRepository = songRepository;

  @override
  Future<Either<Failure, List<SongEntity>>> call() {
    return _songRepository.getMySongs();
  }
}
