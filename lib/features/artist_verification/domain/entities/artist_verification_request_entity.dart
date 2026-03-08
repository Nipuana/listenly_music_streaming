import 'package:equatable/equatable.dart';

class ArtistVerificationRequestEntity extends Equatable {
  final String? id;
  final String status;
  final String? message;
  final String? adminNote;
  final DateTime? reviewedAt;
  final DateTime? createdAt;

  const ArtistVerificationRequestEntity({
    this.id,
    required this.status,
    this.message,
    this.adminNote,
    this.reviewedAt,
    this.createdAt,
  });

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isDeclined => status.toLowerCase() == 'declined';

  @override
  List<Object?> get props => [id, status, message, adminNote, reviewedAt, createdAt];
}