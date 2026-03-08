import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/api/api_client.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/features/artist_verification/data/models/artist_verification_request_api_model.dart';

final artistVerificationRemoteDatasourceProvider =
    Provider<IArtistVerificationRemoteDatasource>((ref) {
  return ArtistVerificationRemoteDatasource(
    apiClient: ref.watch(apiClientProvider),
  );
});

abstract interface class IArtistVerificationRemoteDatasource {
  Future<ArtistVerificationRequestApiModel?> getMyRequest();
  Future<ArtistVerificationRequestApiModel> submitRequest(String message);
}

class ArtistVerificationRemoteDatasource
    implements IArtistVerificationRemoteDatasource {
  final ApiClient _apiClient;

  ArtistVerificationRemoteDatasource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ArtistVerificationRequestApiModel?> getMyRequest() async {
    final response = await _apiClient.get(ApiEndpoints.myArtistVerificationRequest);
    final data = response.data['data'];

    if (data == null) {
      return null;
    }

    return ArtistVerificationRequestApiModel.fromJson(
      Map<String, dynamic>.from(data as Map),
    );
  }

  @override
  Future<ArtistVerificationRequestApiModel> submitRequest(String message) async {
    final response = await _apiClient.post(
      ApiEndpoints.artistVerificationRequest,
      data: {'message': message.trim()},
    );

    return ArtistVerificationRequestApiModel.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }
}