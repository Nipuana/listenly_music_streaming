import 'package:dartz/dartz.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/features/auth/domain/entities/auth_entities.dart';

abstract interface class IAuthRepository{
  Future<Either<Failure,bool>> register(AuthEntity entity);
  Future<Either<Failure,AuthEntity>> login(String email, String password);
  Future<Either<Failure,AuthEntity>> getCurrentUser();
  Future<Either<Failure,bool>> logout();
  Future<Either<Failure,AuthEntity>> updateUser(AuthEntity entity, {String? filePath});
  Future<Either<Failure,String>> requestPasswordReset(String email);
  Future<Either<Failure,String>> resetPassword({
    required String token,
    required String newPassword,
  });
}