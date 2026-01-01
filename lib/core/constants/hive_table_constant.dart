class HiveTableConstant {
  // Private constructor
  HiveTableConstant._();

  // Database name
  static const String dbName = "listenly_music_db";

  // Tables -> Box : Index
  static const int userTypeId = 0;
  static const String userTable = "user_table";

  static const int musicTypeId = 1;
  static const String musicTable = "music_table";

  static const int playlistTypeId = 2;
  static const String playlistTable = "playlist_table";

  static const int reviewTypeId = 3;
  static const String reviewTable = "review_table";

  static const int likeTypeId = 5;
  static const String likeTable = "like_table";

  static const int commentTypeId = 4;
  static const String commentTable = "comment_table";
}
