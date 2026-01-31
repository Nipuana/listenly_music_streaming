import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/auth/data/repositories/auth_repository.dart';
import 'package:weplay_music_streaming/features/auth/domain/entities/auth_entities.dart';
import 'package:weplay_music_streaming/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserParams extends Equatable {
  final String? username;
  final String? email;
  final String? profilePicture;
  final String? filePath; // For image file upload

  const UpdateUserParams({
    this.username,
    this.email,
    this.profilePicture,
    this.filePath,
  });

  @override
  List<Object?> get props => [username, email, profilePicture, filePath];
}

final updateUserUsecaseProvider = Provider<UpdateUserUsecase>((ref) {
  return UpdateUserUsecase(authRepository: ref.read(authRepositoryProvider));
});

class UpdateUserUsecase implements UsecaseWithParms<AuthEntity, UpdateUserParams> {
  final IAuthRepository _authRepository;

  UpdateUserUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(UpdateUserParams params) {
    final entity = AuthEntity(
      username: params.username ?? '',
      email: params.email ?? '',
      userType: 'User',
      profilePicture: params.profilePicture,
    );
    return _authRepository.updateUser(entity, filePath: params.filePath);
  }
}
