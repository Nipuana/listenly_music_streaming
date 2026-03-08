import 'package:equatable/equatable.dart';

class SongEntity extends Equatable {
  final String? id;
  final String title;
  final String? album;
  final String genre;
  final int? duration;
  final DateTime? releaseDate;
  final String? audioUrl;
  final String? coverImageUrl;
  final int playCount;
  final int likeCount;
  final int listenTimeSeconds;
  final String visibility;
  final String uploadedBy;
  final String? uploadedByUsername;
  final String? uploadedByProfilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isLiked;

  const SongEntity({
    this.id,
    required this.title,
    this.album,
    this.genre = 'other',
    this.duration,
    this.releaseDate,
    this.audioUrl,
    this.coverImageUrl,
    this.playCount = 0,
    this.likeCount = 0,
    this.listenTimeSeconds = 0,
    this.visibility = 'public',
    required this.uploadedBy,
    this.uploadedByUsername,
    this.uploadedByProfilePicture,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        album,
        genre,
        duration,
        releaseDate,
        audioUrl,
        coverImageUrl,
        playCount,
        likeCount,
        listenTimeSeconds,
        visibility,
        uploadedBy,
        uploadedByUsername,
        uploadedByProfilePicture,
        createdAt,
        updatedAt,
        isLiked,
      ];

  SongEntity copyWith({
    String? id,
    String? title,
    String? album,
    String? genre,
    int? duration,
    DateTime? releaseDate,
    String? audioUrl,
    String? coverImageUrl,
    int? playCount,
    int? likeCount,
    int? listenTimeSeconds,
    String? visibility,
    String? uploadedBy,
    String? uploadedByUsername,
    String? uploadedByProfilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLiked,
  }) {
    return SongEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      album: album ?? this.album,
      genre: genre ?? this.genre,
      duration: duration ?? this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      audioUrl: audioUrl ?? this.audioUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      playCount: playCount ?? this.playCount,
      likeCount: likeCount ?? this.likeCount,
      listenTimeSeconds: listenTimeSeconds ?? this.listenTimeSeconds,
      visibility: visibility ?? this.visibility,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedByUsername: uploadedByUsername ?? this.uploadedByUsername,
      uploadedByProfilePicture: uploadedByProfilePicture ?? this.uploadedByProfilePicture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'album': album,
      'genre': genre,
      'duration': duration,
      'releaseDate': releaseDate?.toIso8601String(),
      'audioUrl': audioUrl,
      'coverImageUrl': coverImageUrl,
      'playCount': playCount,
      'likeCount': likeCount,
      'listenTimeSeconds': listenTimeSeconds,
      'visibility': visibility,
      'uploadedBy': uploadedBy,
      'uploadedByUsername': uploadedByUsername,
      'uploadedByProfilePicture': uploadedByProfilePicture,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isLiked': isLiked,
    };
  }

  factory SongEntity.fromJson(Map<String, dynamic> json) {
    return SongEntity(
      id: json['id'] as String?,
      title: json['title'] as String,
      album: json['album'] as String?,
      genre: json['genre'] as String? ?? 'other',
      duration: json['duration'] as int?,
      releaseDate: json['releaseDate'] != null 
          ? DateTime.tryParse(json['releaseDate'] as String) 
          : null,
      audioUrl: json['audioUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      playCount: json['playCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      listenTimeSeconds: json['listenTimeSeconds'] as int? ?? 0,
      visibility: json['visibility'] as String? ?? 'public',
      uploadedBy: json['uploadedBy'] as String,
      uploadedByUsername: json['uploadedByUsername'] as String?,
      uploadedByProfilePicture: json['uploadedByProfilePicture'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'] as String) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt'] as String) 
          : null,
      isLiked: json['isLiked'] as bool?,
    );
  }
}
