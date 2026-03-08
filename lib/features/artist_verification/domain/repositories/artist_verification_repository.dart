import 'package:dartz/dartz.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/entities/artist_verification_request_entity.dart';

abstract interface class IArtistVerificationRepository {
  Future<Either<Failure, ArtistVerificationRequestEntity?>> getMyRequest();
  Future<Either<Failure, ArtistVerificationRequestEntity>> submitRequest(String message);
}