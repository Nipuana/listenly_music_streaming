import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:weplay_music_streaming/features/profile/presentation/state/profile_state.dart';

final profileViewModelProvider = NotifierProvider<ProfileViewModel, ProfileState>(
  () => ProfileViewModel(),
);

class ProfileViewModel extends Notifier<ProfileState> {
  late final UpdateUserUsecase _updateUserUsecase;

  @override
  ProfileState build() {
    _updateUserUsecase = ref.read(updateUserUsecaseProvider);
    return const ProfileState();
  }

  Future<void> updateUser({
    String? username,
    String? email,
    String? profilePicture,
    String? filePath,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading);

    await Future.delayed(const Duration(seconds: 1));
    
    final params = UpdateUserParams(
      username: username,
      email: email,
      profilePicture: profilePicture,
      filePath: filePath,
    );

    final result = await _updateUserUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: ProfileStatus.success,
          authEntity: authEntity,
        );
      },
    );
  }
}
