import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice=true;

   static const String computerIpAdress="192.168.1.2";


  static String get baseUrl {
    if(isPhysicalDevice){
      return "http://$computerIpAdress:5000/api/";
    }
    if (kIsWeb){
      return 'http://localhost:5000/api/';
    }else if(Platform.isAndroid){
      return 'http://10.0.2.2:5000/api/';
    }else if(Platform.isIOS){
      return "http://localhost:5000/api/";
    }
    else{
      return "http://localhost:5000/api/";
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);


  // ============ User Endpoints ============
  static const String registerUser = 'auth/register';
  static const String loginUser = 'auth/login';
  static const String updateUser= 'auth/update-profile';
  static const String getUserProfileById = 'auth/profile';
  static const String requestPasswordReset = 'auth/request-password-reset';
  static String resetPassword(String token) => 'auth/reset-password/$token';

  // ============ Song Endpoints ============
  static const String getAllSongs = 'songs/get-all-songs';
  static const String mySongs = 'songs/my-songs';
  static String songsByUser(String userId) => 'songs/getSongByuserId/$userId';
  static String songsByGenre(String genre) => 'songs/getSongsBygenre/$genre';
  static String songById(String id) => 'songs/getSongById/$id';
  static const String songStatsOverall = 'songs/stats/overall';
  static String playCount(String id) => 'songs/play-count/$id';
  static String listenTime(String id) => 'songs/listen-time/$id';
  static const String createSong = 'songs/create-song';
  static String updateSong(String id) => 'songs/update-song/$id';
  static String deleteSong(String id) => 'songs/del-song/$id';

  // ============ Like Endpoints ============
  static const String likedSongs = 'songs/user/liked-songs';
  static String likeStatus(String id) => 'songs/like-status/$id/liked';
  static String changeLikeStatus(String id) => 'songs/change-like-status/$id';

  // ============ Playlist Endpoints ============
  static const String getAllPlaylists = 'playlists/get-all';
  static const String myPlaylists = 'playlists/user/my-playlists';
  static String getPlaylistById(String id) => 'playlists/getPlaylistById/$id';
  static const String createPlaylist = 'playlists/create-playlist';
  static String updatePlaylist(String id) => 'playlists/update-playlist/$id';
  static String deletePlaylist(String id) => 'playlists/delete-playlist/$id';
  static String addSongToPlaylist(String id) => 'playlists/$id/songs';
  static String removeSongFromPlaylist(String id, String songId) => 'playlists/remove-song-from-playlist/$id/$songId';
  static String reorderSongs(String id) => 'playlists/reorder-songs/$id';

  // ============ Playlist Favorite Endpoints ============
  static const String getFavoritedPlaylists = 'playlists/user/favorited';
  static String checkPlaylistFavorited(String id) => 'playlists/$id/favorited';
  static String togglePlaylistFavorite(String id) => 'playlists/$id/favorite';

  // ============ User Info Endpoints ============
  static const String addUserInfo = 'userInfo/add-info';
  static const String getUserInfo = 'userInfo/get-info';
  static const String clearUserInfo = 'userInfo/clear-info';

  // ============ Artist Verification Endpoints ============
  static const String artistVerificationRequest = 'artist-verification/request';
  static const String myArtistVerificationRequest = 'artist-verification/my-request';
  static const String adminArtistVerificationRequests = 'admin/artist-verification/requests';
  static String adminApproveArtistVerification(String id) => 'admin/artist-verification/requests/$id/approve';
  static String adminDeclineArtistVerification(String id) => 'admin/artist-verification/requests/$id/decline';

  // ============ Artist Dashboard Endpoints ============
  // Uses existing song endpoints - artists manage their own songs
  static const String artistDashboardStats = 'songs/stats/overall';
  static const String artistSongs = 'songs/my-songs';
  static String artistSongDetails(String id) => 'songs/getSongById/$id';

}
