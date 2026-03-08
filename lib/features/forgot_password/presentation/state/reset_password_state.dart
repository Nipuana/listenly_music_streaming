import 'package:equatable/equatable.dart';

enum ResetPasswordStatus {
  initial,
  loading,
  success,
  error,
}

class ResetPasswordState extends Equatable {
  final ResetPasswordStatus status;
  final String? successMessage;
  final String? errorMessage;

  const ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? successMessage,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, successMessage, errorMessage];
}