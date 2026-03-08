import 'package:equatable/equatable.dart';
import 'song_entity.dart';

class PlaylistEntity extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final String? coverImageUrl;
  final String visibility;
  final String createdBy;
  final String? createdByUsername;
  final List<SongEntity> songs;
  final int favoriteCount;
  final int songCount;
  final int totalDuration;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isFavorited;

  const PlaylistEntity({
    this.id,
    required this.name,
    this.description,
    this.coverImageUrl,
    this.visibility = 'public',
    required this.createdBy,
    this.createdByUsername,
    this.songs = const [],
    this.favoriteCount = 0,
    this.songCount = 0,
    this.totalDuration = 0,
    this.createdAt,
    this.updatedAt,
    this.isFavorited,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        coverImageUrl,
        visibility,
        createdBy,
        createdByUsername,
        songs,
        favoriteCount,
        songCount,
        totalDuration,
        createdAt,
        updatedAt,
        isFavorited,
      ];

  PlaylistEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? coverImageUrl,
    String? visibility,
    String? createdBy,
    String? createdByUsername,
    List<SongEntity>? songs,
    int? favoriteCount,
    int? songCount,
    int? totalDuration,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorited,
  }) {
    return PlaylistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      visibility: visibility ?? this.visibility,
      createdBy: createdBy ?? this.createdBy,
      createdByUsername: createdByUsername ?? this.createdByUsername,
      songs: songs ?? this.songs,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      songCount: songCount ?? this.songCount,
      totalDuration: totalDuration ?? this.totalDuration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
