import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/artist/data/repositories/artist_repository_impl.dart';
import 'package:weplay_music_streaming/features/artist/domain/repositories/artist_repository.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

final updateArtistSongUsecaseProvider = Provider<UpdateArtistSongUsecase>((ref) {
  return UpdateArtistSongUsecase(artistRepository: ref.read(artistRepositoryProvider));
});

class UpdateArtistSongParams extends Equatable {
  final String songId;
  final String title;
  final String genre;
  final String visibility;

  const UpdateArtistSongParams({
    required this.songId,
    required this.title,
    required this.genre,
    required this.visibility,
  });

  @override
  List<Object?> get props => [songId, title, genre, visibility];
}

class UpdateArtistSongUsecase implements UsecaseWithParms<SongEntity, UpdateArtistSongParams> {
  final IArtistRepository _artistRepository;

  UpdateArtistSongUsecase({required IArtistRepository artistRepository})
      : _artistRepository = artistRepository;

  @override
  Future<Either<Failure, SongEntity>> call(UpdateArtistSongParams params) {
    return _artistRepository.updateArtistSong(params);
  }
}