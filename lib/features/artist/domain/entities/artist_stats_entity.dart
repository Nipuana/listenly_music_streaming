import 'package:equatable/equatable.dart';

/// Artist statistics entity - represents aggregated stats from the artist's songs
class ArtistStatsEntity extends Equatable {
  final int totalSongs;
  final int totalStreams;
  final int totalListenTimeSeconds;

  const ArtistStatsEntity({
    required this.totalSongs,
    required this.totalStreams,
    required this.totalListenTimeSeconds,
  });

  /// Formats total listen time into human-readable hours and minutes
  String get totalListenTime {
    final hours = totalListenTimeSeconds ~/ 3600;
    final minutes = (totalListenTimeSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  List<Object?> get props => [
        totalSongs,
        totalStreams,
        totalListenTimeSeconds,
      ];
}
