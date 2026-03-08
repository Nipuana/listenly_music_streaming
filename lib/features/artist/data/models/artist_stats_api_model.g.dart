// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_stats_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistStatsApiModel _$ArtistStatsApiModelFromJson(Map<String, dynamic> json) =>
    ArtistStatsApiModel(
      songCount: (json['songCount'] as num).toInt(),
      totalStreams: (json['totalStreams'] as num).toInt(),
      totalListenTimeSeconds: (json['totalListenTimeSeconds'] as num).toInt(),
    );

Map<String, dynamic> _$ArtistStatsApiModelToJson(
        ArtistStatsApiModel instance) =>
    <String, dynamic>{
      'songCount': instance.songCount,
      'totalStreams': instance.totalStreams,
      'totalListenTimeSeconds': instance.totalListenTimeSeconds,
    };
