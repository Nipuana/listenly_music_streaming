import 'package:equatable/equatable.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/playlist_entity.dart';

enum LibraryStatus {
  initial,
  loading,
  success,
  error,
}

enum LibraryTab {
  songs,
  playlists,
}

enum PlaylistFilter {
  myPlaylists,
  allPlaylists,
  favoritePlaylists,
}

class LibraryState extends Equatable {
  final LibraryStatus status;
  final LibraryTab selectedTab;
  final PlaylistFilter playlistFilter;
  final String selectedGenre;
  final List<SongEntity> songs;
  final List<PlaylistEntity> playlists;
  final List<PlaylistEntity> userPlaylists; // For add to playlist dropdown
  final String searchQuery;
  final String? errorMessage;

  const LibraryState({
    this.status = LibraryStatus.initial,
    this.selectedTab = LibraryTab.songs,
    this.playlistFilter = PlaylistFilter.myPlaylists,
    this.selectedGenre = 'All',
    this.songs = const [],
    this.playlists = const [],
    this.userPlaylists = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  LibraryState copyWith({
    LibraryStatus? status,
    LibraryTab? selectedTab,
    PlaylistFilter? playlistFilter,
    String? selectedGenre,
    List<SongEntity>? songs,
    List<PlaylistEntity>? playlists,
    List<PlaylistEntity>? userPlaylists,
    String? searchQuery,
    String? errorMessage,
  }) {
    return LibraryState(
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
      playlistFilter: playlistFilter ?? this.playlistFilter,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      songs: songs ?? this.songs,
      playlists: playlists ?? this.playlists,
      userPlaylists: userPlaylists ?? this.userPlaylists,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedTab,
        playlistFilter,
        selectedGenre,
        songs,
        playlists,
        userPlaylists,
        searchQuery,
        errorMessage,
      ];
}
