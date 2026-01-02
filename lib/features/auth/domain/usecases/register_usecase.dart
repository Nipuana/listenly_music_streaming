import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/auth/data/repositories/auth_repository.dart';
import 'package:weplay_music_streaming/features/auth/domain/entities/auth_entities.dart';
import 'package:weplay_music_streaming/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecaseParams extends Equatable{
  final String username;
  final String email;
  final String? userType;
  final String password;

  const RegisterUsecaseParams({
    required this.username,
    required this.email,
    this.userType,
    required this.password,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    userType,
    password
  ];
}


// Make Provider

final registerUsecaseProvider =  Provider<RegisterUsecase>((ref){
  return RegisterUsecase(authRepository: ref.read(authRepositoryProvider));
}); 
class RegisterUsecase implements UsecaseWithParms<bool,RegisterUsecaseParams>{

  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
   : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      username: params.username,
      email: params.email,
      userType: params.userType ?? 'User',
      password: params.password,
    );
    return _authRepository.register(entity);
  }


}