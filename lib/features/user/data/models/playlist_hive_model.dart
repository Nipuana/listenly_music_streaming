import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:weplay_music_streaming/core/constants/hive_table_constant.dart';
import 'package:weplay_music_streaming/features/user/data/models/playlist_api_model.dart';
import 'package:weplay_music_streaming/features/user/data/models/song_api_model.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

part 'playlist_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.playlistTypeId)
class PlaylistHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? coverImageUrl;

  @HiveField(4)
  final String visibility;

  @HiveField(5)
  final String? createdBy;

  @HiveField(6)
  final String? createdByUsername;

  /// JSON-encoded List<Map> of song objects (to avoid needing a nested TypeAdapter)
  @HiveField(7)
  final String songsJson;

  @HiveField(8)
  final int favoriteCount;

  @HiveField(9)
  final int songCount;

  @HiveField(10)
  final int totalDuration;

  @HiveField(11)
  final bool? isFavorited;

  /// ISO-8601 timestamp of when this entry was cached
  @HiveField(12)
  final String cachedAt;

  /// Logical collection key, e.g. 'all_playlists', 'my_playlists', 'favorited_playlists', 'playlist_{id}'
  @HiveField(13)
  final String collectionKey;

  PlaylistHiveModel({
    this.id,
    required this.name,
    this.description,
    this.coverImageUrl,
    required this.visibility,
    this.createdBy,
    this.createdByUsername,
    required this.songsJson,
    required this.favoriteCount,
    required this.songCount,
    required this.totalDuration,
    this.isFavorited,
    required this.cachedAt,
    required this.collectionKey,
  });

  factory PlaylistHiveModel.fromApiModel(
    PlaylistApiModel model, {
    required String collectionKey,
  }) {
    // Encode songs list to JSON string; keep raw dynamic list as-is
    final encodedSongs = jsonEncode(model.songs);

    return PlaylistHiveModel(
      id: model.id,
      name: model.name,
      description: model.description,
      coverImageUrl: model.coverImageUrl,
      visibility: model.visibility,
      createdBy: model.createdBy,
      createdByUsername: model.createdByData?['username'] as String?,
      songsJson: encodedSongs,
      favoriteCount: model.favoriteCount,
      songCount: model.songCount,
      totalDuration: model.totalDuration,
      isFavorited: model.isFavorited,
      cachedAt: DateTime.now().toIso8601String(),
      collectionKey: collectionKey,
    );
  }

  PlaylistEntity toEntity() {
    // Decode songs from JSON string back to entity list
    List<SongEntity> songs = [];
    try {
      final decoded = jsonDecode(songsJson) as List<dynamic>;
      songs = decoded
          .whereType<Map<String, dynamic>>()
          .map((json) {
            try {
              return SongApiModel.fromJson(json).toEntity();
            } catch (_) {
              return null;
            }
          })
          .whereType<SongEntity>()
          .toList();
    } catch (_) {
      songs = [];
    }

    return PlaylistEntity(
      id: id,
      name: name,
      description: description,
      coverImageUrl: coverImageUrl,
      visibility: visibility,
      createdBy: createdBy ?? '',
      createdByUsername: createdByUsername,
      songs: songs,
      favoriteCount: favoriteCount,
      songCount: songCount,
      totalDuration: totalDuration,
      isFavorited: isFavorited,
    );
  }
}
