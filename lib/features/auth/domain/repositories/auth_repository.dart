import 'package:dartz/dartz.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/features/auth/domain/entities/auth_entities.dart';

abstract interface class IAuthRepository{
  Future<Either<Failure,bool>> registerUser(AuthEntity entity);
  Future<Either<Failure,AuthEntity>> loginUser(String email, String password);
  Future<Either<Failure,AuthEntity>> getCurrentUser();
  Future<Either<Failure,bool>> logout();
}