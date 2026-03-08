// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongApiModel _$SongApiModelFromJson(Map<String, dynamic> json) => SongApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      album: json['album'] as String?,
      genre: json['genre'] as String? ?? 'other',
      duration: (json['duration'] as num?)?.toInt(),
      releaseDate: json['releaseDate'] as String?,
      audioUrl: json['audioUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      listenTimeSeconds: (json['listenTimeSeconds'] as num?)?.toInt() ?? 0,
      visibility: json['visibility'] as String? ?? 'public',
      uploadedBy: json['uploadedBy'] as String?,
      uploadedByData: json['uploadedByData'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isLiked: json['isLiked'] as bool?,
    );

Map<String, dynamic> _$SongApiModelToJson(SongApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'album': instance.album,
      'genre': instance.genre,
      'duration': instance.duration,
      'releaseDate': instance.releaseDate,
      'audioUrl': instance.audioUrl,
      'coverImageUrl': instance.coverImageUrl,
      'playCount': instance.playCount,
      'likeCount': instance.likeCount,
      'listenTimeSeconds': instance.listenTimeSeconds,
      'visibility': instance.visibility,
      'uploadedBy': instance.uploadedBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isLiked': instance.isLiked,
    };
