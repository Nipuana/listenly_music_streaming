import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:weplay_music_streaming/features/forgot_password/presentation/state/reset_password_state.dart';

final resetPasswordViewModelProvider =
    NotifierProvider<ResetPasswordViewModel, ResetPasswordState>(
  ResetPasswordViewModel.new,
);

class ResetPasswordViewModel extends Notifier<ResetPasswordState> {
  late final ResetPasswordUsecase _resetPasswordUsecase;

  @override
  ResetPasswordState build() {
    _resetPasswordUsecase = ref.read(resetPasswordUsecaseProvider);
    return const ResetPasswordState();
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = const ResetPasswordState(status: ResetPasswordStatus.loading);

    final result = await _resetPasswordUsecase(
      ResetPasswordParams(
        token: token.trim(),
        newPassword: newPassword,
      ),
    );

    result.fold(
      (failure) {
        state = ResetPasswordState(
          status: ResetPasswordStatus.error,
          errorMessage: failure.message,
        );
      },
      (message) {
        state = ResetPasswordState(
          status: ResetPasswordStatus.success,
          successMessage: message,
        );
      },
    );
  }
}