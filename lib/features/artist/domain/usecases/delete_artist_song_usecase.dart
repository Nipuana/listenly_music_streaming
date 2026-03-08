import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/artist/data/repositories/artist_repository_impl.dart';
import 'package:weplay_music_streaming/features/artist/domain/repositories/artist_repository.dart';

final deleteArtistSongUsecaseProvider = Provider<DeleteArtistSongUsecase>((ref) {
  return DeleteArtistSongUsecase(artistRepository: ref.read(artistRepositoryProvider));
});

class DeleteArtistSongParams extends Equatable {
  final String songId;

  const DeleteArtistSongParams({required this.songId});

  @override
  List<Object?> get props => [songId];
}

class DeleteArtistSongUsecase implements UsecaseWithParms<bool, DeleteArtistSongParams> {
  final IArtistRepository _artistRepository;

  DeleteArtistSongUsecase({required IArtistRepository artistRepository})
      : _artistRepository = artistRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteArtistSongParams params) {
    return _artistRepository.deleteArtistSong(params);
  }
}