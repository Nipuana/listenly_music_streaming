import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus {
  initial,
  loading,
  success,
  error,
}

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;
  final String? successMessage;
  final String? errorMessage;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? successMessage,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, successMessage, errorMessage];
}