import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/services/hive/hive_service.dart';
import 'package:weplay_music_streaming/features/user/data/models/playlist_api_model.dart';
import 'package:weplay_music_streaming/features/user/data/models/playlist_hive_model.dart';

// Provider
final playlistLocalDatasourceProvider = Provider<PlaylistLocalDatasource>((ref) {
  return PlaylistLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});

class PlaylistLocalDatasource {
  final HiveService _hiveService;

  PlaylistLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  // -------- Write-through cache --------

  /// Caches [playlists] under [collectionKey], replacing any previous entries.
  Future<void> cachePlaylists(
      String collectionKey, List<PlaylistApiModel> playlists) async {
    final hiveModels = playlists
        .map((p) =>
            PlaylistHiveModel.fromApiModel(p, collectionKey: collectionKey))
        .toList();
    await _hiveService.cachePlaylists(collectionKey, hiveModels);
  }

  // -------- Read from cache --------

  /// Returns cached playlists for [collectionKey] if still within TTL.
  /// Returns null when cache is empty or stale.
  List<PlaylistHiveModel>? getCachedPlaylists(String collectionKey) {
    return _hiveService.getCachedPlaylists(collectionKey);
  }

  /// Returns cached playlists regardless of TTL (offline / stale fallback).
  List<PlaylistHiveModel>? getStaleCachedPlaylists(String collectionKey) {
    return _hiveService.getStaleCachedPlaylists(collectionKey);
  }

  // -------- Cache invalidation --------

  /// Clears all cached entries for [collectionKey].
  /// Call this after mutations (create, delete, add/remove songs, toggle favorite).
  Future<void> invalidate(String collectionKey) async {
    await _hiveService.invalidatePlaylistCollection(collectionKey);
  }
}
