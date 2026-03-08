import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/artist/data/repositories/artist_repository_impl.dart';
import 'package:weplay_music_streaming/features/artist/domain/repositories/artist_repository.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

final getArtistSongsUsecaseProvider = Provider<GetArtistSongsUsecase>((ref) {
  return GetArtistSongsUsecase(artistRepository: ref.read(artistRepositoryProvider));
});

class GetArtistSongsUsecase implements UsecaseWithoutParms<List<SongEntity>> {
  final IArtistRepository _artistRepository;

  GetArtistSongsUsecase({required IArtistRepository artistRepository})
      : _artistRepository = artistRepository;

  @override
  Future<Either<Failure, List<SongEntity>>> call() {
    return _artistRepository.getArtistSongs();
  }
}
