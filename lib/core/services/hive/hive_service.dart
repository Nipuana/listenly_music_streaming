import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weplay_music_streaming/core/constants/hive_table_constant.dart';
import 'package:weplay_music_streaming/features/auth/data/models/auth_hive_model.dart';
import 'package:weplay_music_streaming/features/user/data/models/playlist_hive_model.dart';
import 'package:weplay_music_streaming/features/user/data/models/song_hive_model.dart';


final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {

  // init 
  Future<void> init() async {
   final directory = await getApplicationDocumentsDirectory();
   final path='${directory.path}/${HiveTableConstant.dbName}';
   
   Hive.init(path);
   _registerAdapters();
   await openBoxes();
  }

  // Register Adapters
  void _registerAdapters() {
    if(!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)){
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.musicTypeId)) {
      Hive.registerAdapter(SongHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.playlistTypeId)) {
      Hive.registerAdapter(PlaylistHiveModelAdapter());
    }
  }

  // Open Boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<SongHiveModel>(HiveTableConstant.musicTable);
    await Hive.openBox<PlaylistHiveModel>(HiveTableConstant.playlistTable);
  }

  // Close Boxes
  Future<void> closeBoxes() async {
    await Hive.close();
  }


  // ################################ AUTH QUERIES ################################

  Box<AuthHiveModel> get _authBox =>
    Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  // -------- Register User --------
  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.userId, model);
    return model;
  }

  // -------- Login User --------
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users =  _authBox.values.where(
      (user) => user.email == email && user.password == password);

    if (users.isNotEmpty) {
      return users.first;
    } 
    return null;
  }

  // -------- Get Current User --------
  Future<AuthHiveModel?> getCurrentUser() async {
   return null;
  }

  // -------- Logout User --------
  Future<void> logoutUser() async {
  
  }


  // ################################ SONG CACHE ################################

  Box<SongHiveModel> get _songBox =>
      Hive.box<SongHiveModel>(HiveTableConstant.musicTable);

  /// Box key format: `collectionKey_songId`
  String _songBoxKey(String collectionKey, String? id) =>
      '${collectionKey}_${id ?? 'unknown'}';

  // -------- Cache songs for a logical collection --------
  Future<void> cacheSongs(
      String collectionKey, List<SongHiveModel> models) async {
    // Remove previous entries for this collection
    final staleKeys = _songBox.keys
        .cast<String>()
        .where((k) => k.startsWith('${collectionKey}_'))
        .toList();
    await _songBox.deleteAll(staleKeys);

    // Write new entries
    final entries = {
      for (final m in models) _songBoxKey(collectionKey, m.id): m,
    };
    await _songBox.putAll(entries);

    // Enforce global size cap — evict oldest entries first
    if (_songBox.length > HiveTableConstant.maxSongEntries) {
      await _evictOldestSongs();
    }
  }

  /// Returns cached songs for [collectionKey] only if they are within TTL.
  /// Returns null if cache is missing or stale.
  List<SongHiveModel>? getCachedSongs(String collectionKey) {
    final models = _songBox.values
        .where((m) => m.collectionKey == collectionKey)
        .toList();

    if (models.isEmpty) return null;

    final cachedAt = DateTime.tryParse(models.first.cachedAt);
    if (cachedAt == null) return null;
    if (DateTime.now().difference(cachedAt) > HiveTableConstant.cacheTtl) {
      return null;
    }

    return models;
  }

  /// Returns cached songs for [collectionKey] regardless of TTL — used as
  /// offline fallback when the network is unavailable.
  List<SongHiveModel>? getStaleCachedSongs(String collectionKey) {
    final models = _songBox.values
        .where((m) => m.collectionKey == collectionKey)
        .toList();
    return models.isEmpty ? null : models;
  }

  /// Removes all cache entries for [collectionKey] (call after mutations).
  Future<void> invalidateSongCollection(String collectionKey) async {
    final keys = _songBox.keys
        .cast<String>()
        .where((k) => k.startsWith('${collectionKey}_'))
        .toList();
    await _songBox.deleteAll(keys);
  }

  /// Evicts entries beyond [HiveTableConstant.maxSongEntries], oldest first.
  Future<void> _evictOldestSongs() async {
    final sorted = _songBox.values.toList()
      ..sort((a, b) => a.cachedAt.compareTo(b.cachedAt));
    final excess = sorted.take(_songBox.length - HiveTableConstant.maxSongEntries);
    final keysToRemove = excess
        .map((m) => _songBoxKey(m.collectionKey, m.id))
        .toList();
    await _songBox.deleteAll(keysToRemove);
  }


  // ############################## PLAYLIST CACHE ##############################

  Box<PlaylistHiveModel> get _playlistBox =>
      Hive.box<PlaylistHiveModel>(HiveTableConstant.playlistTable);

  String _playlistBoxKey(String collectionKey, String? id) =>
      '${collectionKey}_${id ?? 'unknown'}';

  // -------- Cache playlists for a logical collection --------
  Future<void> cachePlaylists(
      String collectionKey, List<PlaylistHiveModel> models) async {
    // Remove previous entries for this collection
    final staleKeys = _playlistBox.keys
        .cast<String>()
        .where((k) => k.startsWith('${collectionKey}_'))
        .toList();
    await _playlistBox.deleteAll(staleKeys);

    // Write new entries
    final entries = {
      for (final m in models) _playlistBoxKey(collectionKey, m.id): m,
    };
    await _playlistBox.putAll(entries);

    // Enforce global size cap
    if (_playlistBox.length > HiveTableConstant.maxPlaylistEntries) {
      await _evictOldestPlaylists();
    }
  }

  /// Returns cached playlists for [collectionKey] only if within TTL.
  List<PlaylistHiveModel>? getCachedPlaylists(String collectionKey) {
    final models = _playlistBox.values
        .where((m) => m.collectionKey == collectionKey)
        .toList();

    if (models.isEmpty) return null;

    final cachedAt = DateTime.tryParse(models.first.cachedAt);
    if (cachedAt == null) return null;
    if (DateTime.now().difference(cachedAt) > HiveTableConstant.cacheTtl) {
      return null;
    }

    return models;
  }

  /// Returns cached playlists regardless of TTL — offline fallback.
  List<PlaylistHiveModel>? getStaleCachedPlaylists(String collectionKey) {
    final models = _playlistBox.values
        .where((m) => m.collectionKey == collectionKey)
        .toList();
    return models.isEmpty ? null : models;
  }

  /// Removes all cache entries for [collectionKey].
  Future<void> invalidatePlaylistCollection(String collectionKey) async {
    final keys = _playlistBox.keys
        .cast<String>()
        .where((k) => k.startsWith('${collectionKey}_'))
        .toList();
    await _playlistBox.deleteAll(keys);
  }

  /// Evicts entries beyond [HiveTableConstant.maxPlaylistEntries], oldest first.
  Future<void> _evictOldestPlaylists() async {
    final sorted = _playlistBox.values.toList()
      ..sort((a, b) => a.cachedAt.compareTo(b.cachedAt));
    final excess = sorted
        .take(_playlistBox.length - HiveTableConstant.maxPlaylistEntries);
    final keysToRemove = excess
        .map((m) => _playlistBoxKey(m.collectionKey, m.id))
        .toList();
    await _playlistBox.deleteAll(keysToRemove);
  }

}