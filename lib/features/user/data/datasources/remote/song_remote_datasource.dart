import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/api/api_client.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/features/user/data/models/song_api_model.dart';

abstract interface class ISongRemoteDatasource {
  Future<List<SongApiModel>> getAllSongs();
  Future<List<SongApiModel>> getMySongs();
  Future<List<SongApiModel>> getLikedSongs();
  Future<List<SongApiModel>> getSongsByGenre(String genre);
  Future<SongApiModel> getSongById(String id);
  Future<bool> toggleLike(String songId);
  Future<bool> checkIfLiked(String songId);
}

final songRemoteDataSourceProvider = Provider<ISongRemoteDatasource>((ref) {
  return SongRemoteDatasource(
    apiClient: ref.watch(apiClientProvider),
  );
});

class SongRemoteDatasource implements ISongRemoteDatasource {
  final ApiClient _apiClient;

  SongRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<SongApiModel>> getAllSongs() async {
    final response = await _apiClient.get(ApiEndpoints.getAllSongs);
    
    if (response.data['success'] == true) {
      final List<dynamic> songsData = response.data['data'] as List<dynamic>;
      return songsData.map((json) => SongApiModel.fromJson(json as Map<String, dynamic>)).toList();
    }
    return [];
  }

  @override
  Future<List<SongApiModel>> getMySongs() async {
    final response = await _apiClient.get(ApiEndpoints.mySongs);
    
    if (response.data['success'] == true) {
      final List<dynamic> songsData = response.data['data'] as List<dynamic>;
      return songsData.map((json) => SongApiModel.fromJson(json as Map<String, dynamic>)).toList();
    }
    return [];
  }

  @override
  Future<List<SongApiModel>> getLikedSongs() async {
    final response = await _apiClient.get(ApiEndpoints.likedSongs);
    
    if (response.data['success'] == true) {
      final List<dynamic> songsData = response.data['data'] as List<dynamic>;
      return songsData.map((json) => SongApiModel.fromJson(json as Map<String, dynamic>)).toList();
    }
    return [];
  }

  @override
  Future<List<SongApiModel>> getSongsByGenre(String genre) async {
    final response = await _apiClient.get(ApiEndpoints.songsByGenre(genre));
    
    if (response.data['success'] == true) {
      final List<dynamic> songsData = response.data['data'] as List<dynamic>;
      return songsData.map((json) => SongApiModel.fromJson(json as Map<String, dynamic>)).toList();
    }
    return [];
  }

  @override
  Future<SongApiModel> getSongById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.songById(id));
    
    if (response.data['success'] == true) {
      final songData = response.data['data'] as Map<String, dynamic>;
      return SongApiModel.fromJson(songData);
    }
    throw Exception('Failed to get song by id');
  }

  @override
  Future<bool> toggleLike(String songId) async {
    final response = await _apiClient.post(ApiEndpoints.changeLikeStatus(songId));
    
    if (response.data['success'] == true) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> checkIfLiked(String songId) async {
    final response = await _apiClient.get(ApiEndpoints.likeStatus(songId));
    
    if (response.data['success'] == true) {
      return response.data['data']['isLiked'] as bool? ?? false;
    }
    return false;
  }
}
