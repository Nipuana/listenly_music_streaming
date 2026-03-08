import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/usecases/get_my_artist_verification_request_usecase.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/usecases/submit_artist_verification_request_usecase.dart';
import 'package:weplay_music_streaming/features/artist_verification/presentation/state/artist_verification_state.dart';

final artistVerificationViewModelProvider =
    NotifierProvider<ArtistVerificationViewModel, ArtistVerificationState>(
  ArtistVerificationViewModel.new,
);

class ArtistVerificationViewModel extends Notifier<ArtistVerificationState> {
  late final GetMyArtistVerificationRequestUsecase _getMyRequestUsecase;
  late final SubmitArtistVerificationRequestUsecase _submitRequestUsecase;

  @override
  ArtistVerificationState build() {
    _getMyRequestUsecase = ref.read(getMyArtistVerificationRequestUsecaseProvider);
    _submitRequestUsecase = ref.read(submitArtistVerificationRequestUsecaseProvider);
    return const ArtistVerificationState();
  }

  Future<void> loadMyRequest() async {
    state = state.copyWith(
      status: ArtistVerificationStatusState.loading,
      clearErrorMessage: true,
      clearSuccessMessage: true,
    );

    final result = await _getMyRequestUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ArtistVerificationStatusState.error,
          errorMessage: failure.message,
        );
      },
      (request) {
        state = state.copyWith(
          status: ArtistVerificationStatusState.success,
          currentRequest: request,
          clearErrorMessage: true,
          clearSuccessMessage: true,
        );
      },
    );
  }

  Future<void> submitRequest(String message) async {
    state = state.copyWith(
      status: ArtistVerificationStatusState.submitting,
      clearErrorMessage: true,
      clearSuccessMessage: true,
    );

    final result = await _submitRequestUsecase(
      SubmitArtistVerificationRequestParams(message: message.trim()),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ArtistVerificationStatusState.error,
          errorMessage: failure.message,
        );
      },
      (request) {
        state = state.copyWith(
          status: ArtistVerificationStatusState.success,
          currentRequest: request,
          successMessage: 'Artist verification request submitted',
          clearErrorMessage: true,
        );
      },
    );
  }
}