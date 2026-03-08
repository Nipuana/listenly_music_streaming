import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/auth/data/repositories/auth_repository.dart';
import 'package:weplay_music_streaming/features/auth/domain/repositories/auth_repository.dart';

class RequestPasswordResetParams extends Equatable {
  final String email;

  const RequestPasswordResetParams({required this.email});

  @override
  List<Object?> get props => [email];
}

final requestPasswordResetUsecaseProvider = Provider<RequestPasswordResetUsecase>((ref) {
  return RequestPasswordResetUsecase(
    authRepository: ref.read(authRepositoryProvider),
  );
});

class RequestPasswordResetUsecase
    implements UsecaseWithParms<String, RequestPasswordResetParams> {
  final IAuthRepository _authRepository;

  RequestPasswordResetUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, String>> call(RequestPasswordResetParams params) {
    return _authRepository.requestPasswordReset(params.email);
  }
}