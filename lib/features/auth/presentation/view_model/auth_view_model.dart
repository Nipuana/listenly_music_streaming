import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/login_usecase.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/register_usecase.dart';
import '../state/auth_state.dart';


final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState>{

 late final RegisterUsecase _registerUsecase;
 late final LoginUsecase _loginUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return AuthState();
  }

  Future<void> register({
    required String username,
    required String email, 
    required String password, 
    }) async {
    state = state.copyWith(status: AuthStatus.loading);


  // wait for 2 seconsds to simulate network call
    await Future.delayed(const Duration(seconds: 2));
    final params = RegisterUsecaseParams(
      username: username,
      email: email,
      password: password,
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
}