import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/api/api_client.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/features/user/data/models/playlist_api_model.dart';

abstract interface class IPlaylistRemoteDatasource {
  Future<List<PlaylistApiModel>> getAllPlaylists();
  Future<List<PlaylistApiModel>> getMyPlaylists();
  Future<List<PlaylistApiModel>> getFavoritedPlaylists();
  Future<PlaylistApiModel> getPlaylistById(String id);
  Future<PlaylistApiModel> createPlaylist({
    required String name,
    String? description,
    String? visibility,
    File? coverImage,
  });
  Future<bool> toggleFavorite(String playlistId);
  Future<bool> checkIfFavorited(String playlistId);
  Future<bool> deletePlaylist(String playlistId);
  Future<bool> addSongToPlaylist(String playlistId, String songId);
  Future<bool> removeSongFromPlaylist(String playlistId, String songId);
}

final playlistRemoteDataSourceProvider = Provider<IPlaylistRemoteDatasource>((ref) {
  return PlaylistRemoteDatasource(
    apiClient: ref.watch(apiClientProvider),
  );
});

class PlaylistRemoteDatasource implements IPlaylistRemoteDatasource {
  final ApiClient _apiClient;

  PlaylistRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<PlaylistApiModel>> getAllPlaylists() async {
    final response = await _apiClient.get(ApiEndpoints.getAllPlaylists);
    
    if (response.data['success'] == true) {
      final List<dynamic> playlistsData = response.data['data'] as List<dynamic>;
      return playlistsData
          .map((json) => PlaylistApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<PlaylistApiModel>> getMyPlaylists() async {
    final response = await _apiClient.get(ApiEndpoints.myPlaylists);
    
    if (response.data['success'] == true) {
      final List<dynamic> playlistsData = response.data['data'] as List<dynamic>;
      return playlistsData
          .map((json) => PlaylistApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<PlaylistApiModel>> getFavoritedPlaylists() async {
    final response = await _apiClient.get(ApiEndpoints.getFavoritedPlaylists);
    
    if (response.data['success'] == true) {
      final List<dynamic> playlistsData = response.data['data'] as List<dynamic>;
      final safe = playlistsData.whereType<Map<String, dynamic>>().cast<Map<String, dynamic>>();
      return safe.map((json) => PlaylistApiModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<PlaylistApiModel> getPlaylistById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.getPlaylistById(id));
    
    if (response.data['success'] == true) {
      final playlistData = response.data['data'] as Map<String, dynamic>;
      return PlaylistApiModel.fromJson(playlistData);
    }
    throw Exception('Failed to get playlist by id');
  }

  @override
  Future<PlaylistApiModel> createPlaylist({
    required String name,
    String? description,
    String? visibility,
    File? coverImage,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      if (description != null && description.isNotEmpty) 'description': description,
      if (visibility != null) 'visibility': visibility,
      if (coverImage != null)
        'playlistCover': await MultipartFile.fromFile(
          coverImage.path,
          filename: coverImage.path.split('/').last,
        ),
    });

    final response = await _apiClient.uploadFile(
      ApiEndpoints.createPlaylist,
      formData: formData,
    );
    
    if (response.data['success'] == true) {
      final playlistData = response.data['data'] as Map<String, dynamic>;
      return PlaylistApiModel.fromJson(playlistData);
    }
    throw Exception('Failed to create playlist');
  }

  @override
  Future<bool> toggleFavorite(String playlistId) async {
    final response = await _apiClient.post(ApiEndpoints.togglePlaylistFavorite(playlistId));
    
    if (response.data['success'] == true) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> checkIfFavorited(String playlistId) async {
    final response = await _apiClient.get(ApiEndpoints.checkPlaylistFavorited(playlistId));
    
    if (response.data['success'] == true) {
      return response.data['data']['isFavorited'] as bool? ?? false;
    }
    return false;
  }

  @override
  Future<bool> deletePlaylist(String playlistId) async {
    final response = await _apiClient.delete(ApiEndpoints.deletePlaylist(playlistId));

    if (response.data['success'] == true) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> addSongToPlaylist(String playlistId, String songId) async {
    final response = await _apiClient.post(
      ApiEndpoints.addSongToPlaylist(playlistId),
      data: {'songId': songId},
    );
    
    if (response.data['success'] == true) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> removeSongFromPlaylist(String playlistId, String songId) async {
    final response = await _apiClient.delete(
      ApiEndpoints.removeSongFromPlaylist(playlistId, songId),
    );
    
    if (response.data['success'] == true) {
      return true;
    }
    return false;
  }
}
