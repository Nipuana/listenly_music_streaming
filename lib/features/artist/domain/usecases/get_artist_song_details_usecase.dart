import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/usecases/app_usecases.dart';
import 'package:weplay_music_streaming/features/artist/data/repositories/artist_repository_impl.dart';
import 'package:weplay_music_streaming/features/artist/domain/repositories/artist_repository.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

final getArtistSongDetailsUsecaseProvider = Provider<GetArtistSongDetailsUsecase>((ref) {
  return GetArtistSongDetailsUsecase(artistRepository: ref.read(artistRepositoryProvider));
});

class GetArtistSongDetailsUsecase implements UsecaseWithParms<SongEntity, GetArtistSongDetailsParams> {
  final IArtistRepository _artistRepository;

  GetArtistSongDetailsUsecase({required IArtistRepository artistRepository})
      : _artistRepository = artistRepository;

  @override
  Future<Either<Failure, SongEntity>> call(GetArtistSongDetailsParams params) {
    return _artistRepository.getArtistSongDetails(params.songId);
  }
}

class GetArtistSongDetailsParams extends Equatable {
  final String songId;

  const GetArtistSongDetailsParams({required this.songId});

  @override
  List<Object?> get props => [songId];
}
