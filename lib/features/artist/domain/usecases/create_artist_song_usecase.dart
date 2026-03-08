import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/artist/data/repositories/artist_repository_impl.dart';
import 'package:weplay_music_streaming/features/artist/domain/repositories/artist_repository.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

final createArtistSongUsecaseProvider = Provider<CreateArtistSongUsecase>((ref) {
  return CreateArtistSongUsecase(artistRepository: ref.read(artistRepositoryProvider));
});

class CreateArtistSongParams extends Equatable {
  final String title;
  final String genre;
  final String visibility;
  final String audioFilePath;
  final String? coverImagePath;

  const CreateArtistSongParams({
    required this.title,
    required this.genre,
    this.visibility = 'public',
    required this.audioFilePath,
    this.coverImagePath,
  });

  @override
  List<Object?> get props => [
        title,
        genre,
        visibility,
        audioFilePath,
        coverImagePath,
      ];
}

class CreateArtistSongUsecase implements UsecaseWithParms<SongEntity, CreateArtistSongParams> {
  final IArtistRepository _artistRepository;

  CreateArtistSongUsecase({required IArtistRepository artistRepository})
      : _artistRepository = artistRepository;

  @override
  Future<Either<Failure, SongEntity>> call(CreateArtistSongParams params) {
    return _artistRepository.createArtistSong(params);
  }
}
