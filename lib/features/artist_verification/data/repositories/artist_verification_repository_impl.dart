import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/services/connectivity/network_info.dart';
import 'package:weplay_music_streaming/features/artist_verification/data/datasources/artist_verification_remote_datasource.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/entities/artist_verification_request_entity.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/repositories/artist_verification_repository.dart';

final artistVerificationRepositoryProvider =
    Provider<IArtistVerificationRepository>((ref) {
  return ArtistVerificationRepositoryImpl(
    remoteDatasource: ref.watch(artistVerificationRemoteDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

class ArtistVerificationRepositoryImpl implements IArtistVerificationRepository {
  final IArtistVerificationRemoteDatasource _remoteDatasource;
  final INetworkInfo _networkInfo;

  ArtistVerificationRepositoryImpl({
    required IArtistVerificationRemoteDatasource remoteDatasource,
    required INetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ArtistVerificationRequestEntity?>> getMyRequest() async {
    if (await _networkInfo.isConnected) {
      try {
        final request = await _remoteDatasource.getMyRequest();
        return Right(request?.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message']?.toString() ??
                'Failed to load verification status',
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }

    return const Left(ApiFailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, ArtistVerificationRequestEntity>> submitRequest(
    String message,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final request = await _remoteDatasource.submitRequest(message);
        return Right(request.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message']?.toString() ??
                'Failed to submit verification request',
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }

    return const Left(ApiFailure(message: 'No internet connection'));
  }
}