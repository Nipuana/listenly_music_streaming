import 'package:equatable/equatable.dart';
import 'package:weplay_music_streaming/features/auth/domain/entities/auth_entities.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final AuthEntity? authEntity;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.authEntity,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    AuthEntity? authEntity,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      authEntity: authEntity ?? this.authEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, authEntity, errorMessage];
}
