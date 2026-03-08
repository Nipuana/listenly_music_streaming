import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/artist_verification/data/repositories/artist_verification_repository_impl.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/entities/artist_verification_request_entity.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/repositories/artist_verification_repository.dart';

final submitArtistVerificationRequestUsecaseProvider =
    Provider<SubmitArtistVerificationRequestUsecase>((ref) {
  return SubmitArtistVerificationRequestUsecase(
    repository: ref.watch(artistVerificationRepositoryProvider),
  );
});

class SubmitArtistVerificationRequestParams extends Equatable {
  final String message;

  const SubmitArtistVerificationRequestParams({required this.message});

  @override
  List<Object?> get props => [message];
}

class SubmitArtistVerificationRequestUsecase
    implements
        UsecaseWithParms<
          ArtistVerificationRequestEntity,
          SubmitArtistVerificationRequestParams
        > {
  final IArtistVerificationRepository _repository;

  SubmitArtistVerificationRequestUsecase({
    required IArtistVerificationRepository repository,
  }) : _repository = repository;

  @override
  Future<Either<Failure, ArtistVerificationRequestEntity>> call(
    SubmitArtistVerificationRequestParams params,
  ) {
    return _repository.submitRequest(params.message);
  }
}