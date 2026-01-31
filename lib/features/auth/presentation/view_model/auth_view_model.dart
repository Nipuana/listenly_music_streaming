import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/features/auth/data/repositories/auth_repository.dart';
import 'package:weplay_music_streaming/features/auth/domain/repositories/auth_repository.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/login_usecase.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/register_usecase.dart';
import '../state/auth_state.dart';


final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState>{

 late final RegisterUsecase _registerUsecase;
 late final LoginUsecase _loginUsecase;
 late final IAuthRepository _authRepository;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _authRepository = ref.read(authRepositoryProvider);
    return AuthState();
  }

  Future<void> register({
    required String username,
    required String email, 
    required String password, 
    required String confirmPassword,
    }) async {
    state = state.copyWith(status: AuthStatus.loading);

    // wait for 2 seconds to simulate network call
    await Future.delayed(const Duration(seconds: 2));
    final params = RegisterUsecaseParams(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    final result = await _registerUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegistered) {
       if(isRegistered){
        state = state.copyWith(status: AuthStatus.registered);
       } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Registration failed',
        );
       }
      },
    );
  }

  Future<void> login({
    required String email, 
    required String password
    }) async {
    state = state.copyWith(status: AuthStatus.loading);
      // wait for 2 seconsds to simulate network call
    await Future.delayed(const Duration(seconds: 2));
    final params = LoginUsecaseParams(
      email: email,
      password: password,
    );
    final result = await _loginUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (success) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: success,
        );
      },
    );
  }

  Future<bool> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _authRepository.logout();
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          authEntity: null,
        );
        return true;
      },
    );
  }
}