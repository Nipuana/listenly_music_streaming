import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/api/api_client.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/delete_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/create_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/update_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/artist/data/models/artist_stats_api_model.dart';
import 'package:weplay_music_streaming/features/user/data/models/song_api_model.dart';

abstract interface class IArtistRemoteDatasource {
  Future<ArtistStatsApiModel> getDashboardStats();
  Future<List<SongApiModel>> getArtistSongs();
  Future<SongApiModel> getArtistSongDetails(String songId);
  Future<SongApiModel> createArtistSong(CreateArtistSongParams params);
  Future<SongApiModel> updateArtistSong(UpdateArtistSongParams params);
  Future<bool> deleteArtistSong(DeleteArtistSongParams params);
}

final artistRemoteDataSourceProvider = Provider<IArtistRemoteDatasource>((ref) {
  return ArtistRemoteDatasource(
    apiClient: ref.watch(apiClientProvider),
  );
});

class ArtistRemoteDatasource implements IArtistRemoteDatasource {
  final ApiClient _apiClient;

  ArtistRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<ArtistStatsApiModel> getDashboardStats() async {
    final response = await _apiClient.get(ApiEndpoints.artistDashboardStats);
    
    if (response.data['success'] == true) {
      final statsData = response.data['data'] as Map<String, dynamic>;
      return ArtistStatsApiModel.fromJson(statsData);
    }
    throw Exception('Failed to get artist dashboard stats');
  }

  @override
  Future<List<SongApiModel>> getArtistSongs() async {
    final response = await _apiClient.get(ApiEndpoints.artistSongs);
    
    if (response.data['success'] == true) {
      final List<dynamic> songsData = response.data['data'] as List<dynamic>;
      return songsData.map((json) => SongApiModel.fromJson(json as Map<String, dynamic>)).toList();
    }
    return [];
  }

  @override
  Future<SongApiModel> getArtistSongDetails(String songId) async {
    final response = await _apiClient.get(ApiEndpoints.artistSongDetails(songId));
    
    if (response.data['success'] == true) {
      final songData = response.data['data'] as Map<String, dynamic>;
      return SongApiModel.fromJson(songData);
    }
    throw Exception('Failed to get artist song details');
  }

  @override
  Future<SongApiModel> createArtistSong(CreateArtistSongParams params) async {
    final formData = FormData.fromMap({
      'title': params.title,
      'genre': params.genre,
      'visibility': params.visibility,
      'audioFile': await MultipartFile.fromFile(
        params.audioFilePath,
        filename: params.audioFilePath.split('/').last,
      ),
      if (params.coverImagePath != null && params.coverImagePath!.isNotEmpty)
        'coverImage': await MultipartFile.fromFile(
          params.coverImagePath!,
          filename: params.coverImagePath!.split('/').last,
        ),
    });

    final response = await _apiClient.uploadFile(
      ApiEndpoints.createSong,
      formData: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );

    if (response.data['success'] == true) {
      final songData = response.data['data'] as Map<String, dynamic>;
      return SongApiModel.fromJson(songData);
    }

    throw Exception(response.data['message'] ?? 'Failed to create song');
  }

  @override
  Future<SongApiModel> updateArtistSong(UpdateArtistSongParams params) async {
    final response = await _apiClient.put(
      ApiEndpoints.updateSong(params.songId),
      data: {
        'title': params.title,
        'genre': params.genre,
        'visibility': params.visibility,
      },
    );

    if (response.data['success'] == true) {
      final songData = response.data['data'] as Map<String, dynamic>;
      return SongApiModel.fromJson(songData);
    }

    throw Exception(response.data['message'] ?? 'Failed to update song');
  }

  @override
  Future<bool> deleteArtistSong(DeleteArtistSongParams params) async {
    final response = await _apiClient.delete(ApiEndpoints.deleteSong(params.songId));

    if (response.data['success'] == true) {
      return true;
    }

    throw Exception(response.data['message'] ?? 'Failed to delete song');
  }
}
