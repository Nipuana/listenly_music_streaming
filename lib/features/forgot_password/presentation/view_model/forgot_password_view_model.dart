import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:weplay_music_streaming/features/forgot_password/presentation/state/forgot_password_state.dart';

final forgotPasswordViewModelProvider =
    NotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>(
  ForgotPasswordViewModel.new,
);

class ForgotPasswordViewModel extends Notifier<ForgotPasswordState> {
  late final RequestPasswordResetUsecase _requestPasswordResetUsecase;

  @override
  ForgotPasswordState build() {
    _requestPasswordResetUsecase = ref.read(requestPasswordResetUsecaseProvider);
    return const ForgotPasswordState();
  }

  Future<void> sendResetLink(String email) async {
    state = const ForgotPasswordState(status: ForgotPasswordStatus.loading);

    final result = await _requestPasswordResetUsecase(
      RequestPasswordResetParams(email: email.trim()),
    );

    result.fold(
      (failure) {
        state = ForgotPasswordState(
          status: ForgotPasswordStatus.error,
          errorMessage: failure.message,
        );
      },
      (message) {
        state = ForgotPasswordState(
          status: ForgotPasswordStatus.success,
          successMessage: message,
        );
      },
    );
  }
}