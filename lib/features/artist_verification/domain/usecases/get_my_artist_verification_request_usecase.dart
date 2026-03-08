import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/artist_verification/data/repositories/artist_verification_repository_impl.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/entities/artist_verification_request_entity.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/repositories/artist_verification_repository.dart';

final getMyArtistVerificationRequestUsecaseProvider =
    Provider<GetMyArtistVerificationRequestUsecase>((ref) {
  return GetMyArtistVerificationRequestUsecase(
    repository: ref.watch(artistVerificationRepositoryProvider),
  );
});

class GetMyArtistVerificationRequestUsecase
    implements UsecaseWithoutParms<ArtistVerificationRequestEntity?> {
  final IArtistVerificationRepository _repository;

  GetMyArtistVerificationRequestUsecase({
    required IArtistVerificationRepository repository,
  }) : _repository = repository;

  @override
  Future<Either<Failure, ArtistVerificationRequestEntity?>> call() {
    return _repository.getMyRequest();
  }
}