// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistApiModel _$PlaylistApiModelFromJson(Map<String, dynamic> json) =>
    PlaylistApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      visibility: json['visibility'] as String? ?? 'public',
      createdBy: json['createdBy'] as String?,
      createdByData: json['createdByData'] as Map<String, dynamic>?,
      songs: json['songs'] as List<dynamic>? ?? [],
      favoriteCount: (json['favoriteCount'] as num?)?.toInt() ?? 0,
      songCount: (json['songCount'] as num?)?.toInt() ?? 0,
      totalDuration: (json['totalDuration'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isFavorited: json['isFavorited'] as bool?,
    );

Map<String, dynamic> _$PlaylistApiModelToJson(PlaylistApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'coverImageUrl': instance.coverImageUrl,
      'visibility': instance.visibility,
      'createdBy': instance.createdBy,
      'songs': instance.songs,
      'favoriteCount': instance.favoriteCount,
      'songCount': instance.songCount,
      'totalDuration': instance.totalDuration,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isFavorited': instance.isFavorited,
    };
