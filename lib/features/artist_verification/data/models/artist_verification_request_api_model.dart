import 'package:weplay_music_streaming/features/artist_verification/domain/entities/artist_verification_request_entity.dart';

class ArtistVerificationRequestApiModel {
  final String? id;
  final String status;
  final String? message;
  final String? adminNote;
  final DateTime? reviewedAt;
  final DateTime? createdAt;

  const ArtistVerificationRequestApiModel({
    this.id,
    required this.status,
    this.message,
    this.adminNote,
    this.reviewedAt,
    this.createdAt,
  });

  factory ArtistVerificationRequestApiModel.fromJson(Map<String, dynamic> json) {
    return ArtistVerificationRequestApiModel(
      id: json['_id']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      message: json['message']?.toString(),
      adminNote: json['adminNote']?.toString(),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.tryParse(json['reviewedAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  ArtistVerificationRequestEntity toEntity() {
    return ArtistVerificationRequestEntity(
      id: id,
      status: status,
      message: message,
      adminNote: adminNote,
      reviewedAt: reviewedAt,
      createdAt: createdAt,
    );
  }
}