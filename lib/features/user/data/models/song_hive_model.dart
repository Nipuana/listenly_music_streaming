import 'package:hive/hive.dart';
import 'package:weplay_music_streaming/core/constants/hive_table_constant.dart';
import 'package:weplay_music_streaming/features/user/data/models/song_api_model.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

part 'song_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.musicTypeId)
class SongHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? album;

  @HiveField(3)
  final String genre;

  @HiveField(4)
  final int? duration;

  @HiveField(5)
  final String? audioUrl;

  @HiveField(6)
  final String? coverImageUrl;

  @HiveField(7)
  final int playCount;

  @HiveField(8)
  final int likeCount;

  @HiveField(9)
  final String visibility;

  @HiveField(10)
  final String? uploadedBy;

  @HiveField(11)
  final String? uploadedByUsername;

  @HiveField(12)
  final String? uploadedByProfilePicture;

  @HiveField(13)
  final bool? isLiked;

  /// ISO-8601 timestamp of when this entry was cached
  @HiveField(14)
  final String cachedAt;

  /// Logical collection this entry belongs to, e.g. 'all_songs', 'liked_songs', 'my_songs'
  @HiveField(15)
  final String collectionKey;

  SongHiveModel({
    this.id,
    required this.title,
    this.album,
    required this.genre,
    this.duration,
    this.audioUrl,
    this.coverImageUrl,
    required this.playCount,
    required this.likeCount,
    required this.visibility,
    this.uploadedBy,
    this.uploadedByUsername,
    this.uploadedByProfilePicture,
    this.isLiked,
    required this.cachedAt,
    required this.collectionKey,
  });

  factory SongHiveModel.fromApiModel(SongApiModel model, {required String collectionKey}) {
    return SongHiveModel(
      id: model.id,
      title: model.title,
      album: model.album,
      genre: model.genre,
      duration: model.duration,
      audioUrl: model.audioUrl,
      coverImageUrl: model.coverImageUrl,
      playCount: model.playCount,
      likeCount: model.likeCount,
      visibility: model.visibility,
      uploadedBy: model.uploadedBy,
      uploadedByUsername: model.uploadedByData?['username'] as String?,
      uploadedByProfilePicture: model.uploadedByData?['profilePicture'] as String?,
      isLiked: model.isLiked,
      cachedAt: DateTime.now().toIso8601String(),
      collectionKey: collectionKey,
    );
  }

  SongEntity toEntity() {
    return SongEntity(
      id: id,
      title: title,
      album: album,
      genre: genre,
      duration: duration,
      audioUrl: audioUrl,
      coverImageUrl: coverImageUrl,
      playCount: playCount,
      likeCount: likeCount,
      visibility: visibility,
      uploadedBy: uploadedBy ?? '',
      uploadedByUsername: uploadedByUsername,
      uploadedByProfilePicture: uploadedByProfilePicture,
      isLiked: isLiked,
    );
  }
}
