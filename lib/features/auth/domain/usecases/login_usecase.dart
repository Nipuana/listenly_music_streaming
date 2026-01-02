import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/auth/data/repositories/auth_repository.dart';
import 'package:weplay_music_streaming/features/auth/domain/entities/auth_entities.dart';
import 'package:weplay_music_streaming/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecaseParams extends Equatable {
  final String email;
  final String password;
  const LoginUsecaseParams({
    required this.email,
    required this.password,
  });
  @override

  List<Object?> get props => [email, password];
}

// Make Provider

final loginUsecaseProvider =  Provider<LoginUsecase>((ref){
  return LoginUsecase(authRepository: ref.read(authRepositoryProvider));
}); 

class LoginUsecase implements UsecaseWithParms<AuthEntity, LoginUsecaseParams>{

   final IAuthRepository _authRepository;

  LoginUsecase({required IAuthRepository authRepository})
   : _authRepository = authRepository;
   
     @override
     Future<Either<Failure, AuthEntity>> call(LoginUsecaseParams params) {
    return _authRepository.login(params.email, params.password);
     }

 
  
  
}