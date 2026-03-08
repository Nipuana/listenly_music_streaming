class HiveTableConstant {
  // Private constructor
  HiveTableConstant._();

  // Database name
  static const String dbName = "listenly_music_db";

  // Tables -> Box : Index
  static const int authTypeId = 0;
  static const String authTable = "auth_table";

  static const int musicTypeId = 1;
  static const String musicTable = "music_table";

  static const int playlistTypeId = 2;
  static const String playlistTable = "playlist_table";

  static const int reviewTypeId = 3;
  static const String reviewTable = "review_table";

  static const int commentTypeId = 4;
  static const String commentTable = "comment_table";

  static const int likeTypeId = 5;
  static const String likeTable = "like_table";

  // ─── Cache policy ───────────────────────────────────────────────────────────

  /// How long a cached collection stays fresh before the repo refetches
  static const Duration cacheTtl = Duration(minutes: 30);

  /// Maximum songs stored across ALL collections combined
  static const int maxSongEntries = 1000;

  /// Maximum playlists stored across ALL collections combined
  static const int maxPlaylistEntries = 200;

  // ─── Collection keys for songs ──────────────────────────────────────────────
  static const String allSongsKey = 'all_songs';
  static const String likedSongsKey = 'liked_songs';
  static const String mySongsKey = 'my_songs';

  // ─── Collection keys for playlists ──────────────────────────────────────────
  static const String allPlaylistsKey = 'all_playlists';
  static const String myPlaylistsKey = 'my_playlists';
  static const String favoritedPlaylistsKey = 'favorited_playlists';

  /// Returns the per-playlist cache key for a given id
  static String playlistDetailKey(String id) => 'playlist_$id';
}
