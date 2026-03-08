import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/artist/data/repositories/artist_repository_impl.dart';
import 'package:weplay_music_streaming/features/artist/domain/entities/artist_stats_entity.dart';
import 'package:weplay_music_streaming/features/artist/domain/repositories/artist_repository.dart';

final getArtistDashboardStatsUsecaseProvider = Provider<GetArtistDashboardStatsUsecase>((ref) {
  return GetArtistDashboardStatsUsecase(artistRepository: ref.read(artistRepositoryProvider));
});

class GetArtistDashboardStatsUsecase implements UsecaseWithoutParms<ArtistStatsEntity> {
  final IArtistRepository _artistRepository;

  GetArtistDashboardStatsUsecase({required IArtistRepository artistRepository})
      : _artistRepository = artistRepository;

  @override
  Future<Either<Failure, ArtistStatsEntity>> call() {
    return _artistRepository.getDashboardStats();
  }
}
