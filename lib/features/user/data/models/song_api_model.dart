import 'package:json_annotation/json_annotation.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

part 'song_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SongApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String? album;
  @JsonKey(defaultValue: 'other')
  final String genre;
  final int? duration;
  final String? releaseDate;
  final String? audioUrl;
  final String? coverImageUrl;
  @JsonKey(defaultValue: 0)
  final int playCount;
  @JsonKey(defaultValue: 0)
  final int likeCount;
  @JsonKey(defaultValue: 0)
  final int listenTimeSeconds;
  @JsonKey(defaultValue: 'public')
  final String visibility;
  final String? uploadedBy;
  @JsonKey(includeToJson: false)
  final Map<String, dynamic>? uploadedByData;
  final String? createdAt;
  final String? updatedAt;
  final bool? isLiked;

  SongApiModel({
    this.id,
    required this.title,
    this.album,
    required this.genre,
    this.duration,
    this.releaseDate,
    this.audioUrl,
    this.coverImageUrl,
    required this.playCount,
    required this.likeCount,
    required this.listenTimeSeconds,
    required this.visibility,
    this.uploadedBy,
    this.uploadedByData,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
  });

  factory SongApiModel.fromJson(Map<String, dynamic> json) {
    // Handle nested uploadedBy object
    if (json['uploadedBy'] is Map) {
      // preserve full object under uploadedByData for username extraction
      try {
        json['uploadedByData'] = Map<String, dynamic>.from(json['uploadedBy'] as Map);
      } catch (_) {
        // fallback: keep as-is
        json['uploadedByData'] = json['uploadedBy'];
      }
      // normalize uploadedBy to id string
      json['uploadedBy'] = (json['uploadedBy'] as Map)[' _id'] ?? (json['uploadedBy'] as Map)['_id'];
    }
    return _$SongApiModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SongApiModelToJson(this);

  SongEntity toEntity() {
    return SongEntity(
      id: id,
      title: title,
      album: album,
      genre: genre,
      duration: duration,
      releaseDate: releaseDate != null ? DateTime.tryParse(releaseDate!) : null,
      audioUrl: audioUrl,
      coverImageUrl: coverImageUrl,
      playCount: playCount,
      likeCount: likeCount,
      listenTimeSeconds: listenTimeSeconds,
      visibility: visibility,
      uploadedBy: uploadedBy ?? '',
      uploadedByUsername: uploadedByData?['username'] as String?,
      uploadedByProfilePicture: uploadedByData?['profilePicture'] as String?,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      isLiked: isLiked,
    );
  }

  factory SongApiModel.fromEntity(SongEntity entity) {
    return SongApiModel(
      id: entity.id,
      title: entity.title,
      album: entity.album,
      genre: entity.genre,
      duration: entity.duration,
      releaseDate: entity.releaseDate?.toIso8601String(),
      audioUrl: entity.audioUrl,
      coverImageUrl: entity.coverImageUrl,
      playCount: entity.playCount,
      likeCount: entity.likeCount,
      listenTimeSeconds: entity.listenTimeSeconds,
      visibility: entity.visibility,
      uploadedBy: entity.uploadedBy,
      createdAt: entity.createdAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
      isLiked: entity.isLiked,
    );
  }

  static List<SongEntity> toEntityList(List<SongApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
