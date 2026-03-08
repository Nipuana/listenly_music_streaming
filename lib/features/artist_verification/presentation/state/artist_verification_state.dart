import 'package:equatable/equatable.dart';
import 'package:weplay_music_streaming/features/artist_verification/domain/entities/artist_verification_request_entity.dart';

enum ArtistVerificationStatusState {
  initial,
  loading,
  submitting,
  success,
  error,
}

class ArtistVerificationState extends Equatable {
  final ArtistVerificationStatusState status;
  final ArtistVerificationRequestEntity? currentRequest;
  final String? successMessage;
  final String? errorMessage;

  const ArtistVerificationState({
    this.status = ArtistVerificationStatusState.initial,
    this.currentRequest,
    this.successMessage,
    this.errorMessage,
  });

  ArtistVerificationState copyWith({
    ArtistVerificationStatusState? status,
    ArtistVerificationRequestEntity? currentRequest,
    bool clearCurrentRequest = false,
    String? successMessage,
    bool clearSuccessMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ArtistVerificationState(
      status: status ?? this.status,
      currentRequest:
          clearCurrentRequest ? null : (currentRequest ?? this.currentRequest),
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, currentRequest, successMessage, errorMessage];
}