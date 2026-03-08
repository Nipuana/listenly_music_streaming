import 'package:json_annotation/json_annotation.dart';
import 'package:weplay_music_streaming/features/user/data/models/song_api_model.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';

part 'playlist_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PlaylistApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String? description;
  final String? coverImageUrl;
  @JsonKey(defaultValue: 'public')
  final String visibility;
  final String? createdBy;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final Map<String, dynamic>? createdByData;
  @JsonKey(defaultValue: [])
  final List<dynamic> songs;
  @JsonKey(defaultValue: 0)
  final int favoriteCount;
  @JsonKey(defaultValue: 0)
  final int songCount;
  @JsonKey(defaultValue: 0)
  final int totalDuration;
  final String? createdAt;
  final String? updatedAt;
  final bool? isFavorited;

  PlaylistApiModel({
    this.id,
    required this.name,
    this.description,
    this.coverImageUrl,
    required this.visibility,
    this.createdBy,
    this.createdByData,
    required this.songs,
    required this.favoriteCount,
    required this.songCount,
    required this.totalDuration,
    this.createdAt,
    this.updatedAt,
    this.isFavorited,
  });

  factory PlaylistApiModel.fromJson(Map<String, dynamic> json) {
    // Handle nested createdBy object: preserve the object in createdByData
    if (json['createdBy'] is Map<String, dynamic>) {
      // copy the nested object to a separate key so generated parser can
      // populate `createdByData` and we convert `createdBy` to the id string
      json['createdByData'] = Map<String, dynamic>.from(json['createdBy']);
      final nested = json['createdBy'] as Map<String, dynamic>;
      json['createdBy'] = nested['_id']?.toString();
    }
    return _$PlaylistApiModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PlaylistApiModelToJson(this);

  PlaylistEntity toEntity() {
    final songEntities = songs
        .where((song) => song != null)
        .map((song) {
          // Cases observed from server:
          // 1) song is an object { songId: { ...populated song... }, position }
          // 2) song is an object { songId: "<id>", position }
          // 3) song is a populated song object (direct fields)
          // 4) song is a raw id string (unlikely in current API)

          if (song is Map<String, dynamic>) {
            // Case: wrapper object with songId
            if (song.containsKey('songId')) {
              final songInfo = song['songId'];
              if (songInfo is Map<String, dynamic>) {
                return SongApiModel.fromJson(songInfo).toEntity();
              }
              if (songInfo is String) {
                // Create minimal SongEntity with id and fallback title
                return SongEntity(
                  id: songInfo,
                  title: 'Unknown Title',
                  uploadedBy: '',
                );
              }
            }

            // Case: direct song data (may have title, etc.)
            try {
              return SongApiModel.fromJson(song).toEntity();
            } catch (_) {
              // Fallback to minimal entity if required fields missing
              final idVal = song['_id'] ?? song['id'];
              return SongEntity(
                id: idVal?.toString(),
                title: song['title']?.toString() ?? 'Unknown Title',
                uploadedBy: '',
              );
            }
          }

          // If it's a plain string id
          if (song is String) {
            return SongEntity(
              id: song,
              title: 'Unknown Title',
              uploadedBy: '',
            );
          }

          // Unknown shape - return a minimal placeholder
          return SongEntity(
            id: null,
            title: 'Unknown Title',
            uploadedBy: '',
          );
        }).toList();

    return PlaylistEntity(
      id: id,
      name: name,
      description: description,
      coverImageUrl: coverImageUrl,
      visibility: visibility,
      createdBy: createdBy ?? '',
      createdByUsername: createdByData?['username'] as String?,
      songs: songEntities,
      favoriteCount: favoriteCount,
      songCount: songCount,
      totalDuration: totalDuration,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      isFavorited: isFavorited,
    );
  }

  factory PlaylistApiModel.fromEntity(PlaylistEntity entity) {
    return PlaylistApiModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      coverImageUrl: entity.coverImageUrl,
      visibility: entity.visibility,
      createdBy: entity.createdBy,
      songs: entity.songs.map((s) => SongApiModel.fromEntity(s).toJson()).toList(),
      favoriteCount: entity.favoriteCount,
      songCount: entity.songCount,
      totalDuration: entity.totalDuration,
      createdAt: entity.createdAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
      isFavorited: entity.isFavorited,
    );
  }

  static List<PlaylistEntity> toEntityList(List<PlaylistApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
