import 'package:json_annotation/json_annotation.dart';
import 'package:weplay_music_streaming/features/artist/domain/entities/artist_stats_entity.dart';

part 'artist_stats_api_model.g.dart';

/// API model for artist stats - matches backend /api/songs/stats/overall response
@JsonSerializable()
class ArtistStatsApiModel {
  final int songCount;
  final int totalStreams;
  final int totalListenTimeSeconds;

  ArtistStatsApiModel({
    required this.songCount,
    required this.totalStreams,
    required this.totalListenTimeSeconds,
  });

  factory ArtistStatsApiModel.fromJson(Map<String, dynamic> json) =>
      _$ArtistStatsApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistStatsApiModelToJson(this);

  ArtistStatsEntity toEntity() {
    return ArtistStatsEntity(
      totalSongs: songCount,
      totalStreams: totalStreams,
      totalListenTimeSeconds: totalListenTimeSeconds,
    );
  }
}
