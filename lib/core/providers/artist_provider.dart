import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/api/api_client.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';

class ArtistProfile {
  final String id;
  final String name;
  final String? imageUrl;
  final String? bio;

  ArtistProfile({required this.id, required this.name, this.imageUrl, this.bio});

  factory ArtistProfile.fromMap(Map<String, dynamic> map) {
    String? profilePic = map['profilePicture'] as String?;
    if (profilePic != null && profilePic.isNotEmpty) {
      if (!profilePic.startsWith('http://') && !profilePic.startsWith('https://')) {
        final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
        final cleanPath = profilePic.startsWith('/') ? profilePic.substring(1) : profilePic;
        profilePic = '$baseUrl/$cleanPath';
      }
    }

    String? bio;
    if (map['additionalInfo'] is Map<String, dynamic>) {
      bio = map['additionalInfo']['bio'] as String?;
    }

    return ArtistProfile(
      id: map['_id']?.toString() ?? map['id']?.toString() ?? '',
      name: map['displayName'] ?? map['username'] ?? 'Unknown',
      imageUrl: profilePic,
      bio: bio,
    );
  }
}

/// Fetch artist profile by id. Returns null on error or if id is null/empty.
final artistProfileProvider = FutureProvider.family<ArtistProfile?, String?>((ref, artistId) async {
  if (artistId == null || artistId.isEmpty) return null;
  final client = ref.read(apiClientProvider);
  try {
    final resp = await client.get('/admin/get-user/$artistId');
    if (resp.statusCode == 200) {
      final responseData = resp.data;
      if (responseData is Map<String, dynamic>) {
        // Extract the nested 'data' field
        final userData = responseData['data'] as Map<String, dynamic>?;
        if (userData != null) {
          return ArtistProfile.fromMap(userData);
        }
      }
    }
    return null;
  } catch (e) {
    return null;
  }
});

/// Fetch artist profile by song ID. Fetches the song first, then the artist.
final artistProfileBySongIdProvider = FutureProvider.family<ArtistProfile?, String?>((ref, songId) async {
  if (songId == null || songId.isEmpty) return null;
  final client = ref.read(apiClientProvider);
  try {
    // First fetch the song to get uploadedBy
    final songResp = await client.get(ApiEndpoints.songById(songId));
    if (songResp.statusCode == 200) {
      final songData = songResp.data;
      if (songData is Map<String, dynamic> && songData['success'] == true) {
        final song = songData['data'] as Map<String, dynamic>?;
        if (song != null) {
          final uploadedBy = song['uploadedBy'];
          // uploadedBy is an object with _id field
          if (uploadedBy is Map<String, dynamic>) {
            final userId = uploadedBy['_id'] as String?;
            if (userId != null && userId.isNotEmpty) {
              // Now fetch the artist profile
              return await ref.watch(artistProfileProvider(userId).future);
            }
          }
        }
      }
    }
    return null;
  } catch (e) {
    return null;
  }
});
