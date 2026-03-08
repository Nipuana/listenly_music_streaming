import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/services/hive/hive_service.dart';
import 'package:weplay_music_streaming/features/user/data/models/song_api_model.dart';
import 'package:weplay_music_streaming/features/user/data/models/song_hive_model.dart';

// Provider
final songLocalDatasourceProvider = Provider<SongLocalDatasource>((ref) {
  return SongLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});

class SongLocalDatasource {
  final HiveService _hiveService;

  SongLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  // -------- Write-through cache --------

  /// Caches [songs] under [collectionKey], replacing any previous entries.
  Future<void> cacheSongs(
      String collectionKey, List<SongApiModel> songs) async {
    final hiveModels = songs
        .map((s) => SongHiveModel.fromApiModel(s, collectionKey: collectionKey))
        .toList();
    await _hiveService.cacheSongs(collectionKey, hiveModels);
  }

  // -------- Read from cache --------

  /// Returns cached songs for [collectionKey] if still within TTL.
  /// Returns null when cache is empty or stale.
  List<SongHiveModel>? getCachedSongs(String collectionKey) {
    return _hiveService.getCachedSongs(collectionKey);
  }

  /// Returns cached songs regardless of TTL (offline / stale fallback).
  List<SongHiveModel>? getStaleCachedSongs(String collectionKey) {
    return _hiveService.getStaleCachedSongs(collectionKey);
  }

  // -------- Cache invalidation --------

  /// Clears all cached entries for [collectionKey].
  /// Call this after mutating songs (e.g. like/unlike) so the next
  /// read re-fetches fresh data.
  Future<void> invalidate(String collectionKey) async {
    await _hiveService.invalidateSongCollection(collectionKey);
  }
}
