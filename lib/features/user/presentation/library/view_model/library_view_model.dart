import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/add_song_to_playlist_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/delete_playlist_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/get_all_playlists_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/get_all_songs_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/get_my_playlists_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/toggle_favorite_playlist_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/usecases/toggle_like_song_usecase.dart';
import 'package:weplay_music_streaming/features/user/presentation/library/state/library_state.dart';
import 'package:weplay_music_streaming/features/user/data/repositories/song_repository_impl.dart';
import 'package:weplay_music_streaming/features/user/data/repositories/playlist_repository_impl.dart';

final libraryViewModelProvider = NotifierProvider<LibraryViewModel, LibraryState>(
  () => LibraryViewModel(),
);

class LibraryViewModel extends Notifier<LibraryState> {
  late final GetAllSongsUsecase _getAllSongsUsecase;
  late final GetAllPlaylistsUsecase _getAllPlaylistsUsecase;
  late final GetMyPlaylistsUsecase _getMyPlaylistsUsecase;
  late final ToggleLikeSongUsecase _toggleLikeSongUsecase;
  late final ToggleFavoritePlaylistUsecase _toggleFavoritePlaylistUsecase;
  late final AddSongToPlaylistUsecase _addSongToPlaylistUsecase;
  late final DeletePlaylistUsecase _deletePlaylistUsecase;
  // repositories accessed directly via ref.read when needed

  @override
  LibraryState build() {
    _getAllSongsUsecase = ref.read(getAllSongsUsecaseProvider);
    _getAllPlaylistsUsecase = ref.read(getAllPlaylistsUsecaseProvider);
    _getMyPlaylistsUsecase = ref.read(getMyPlaylistsUsecaseProvider);
    _toggleLikeSongUsecase = ref.read(toggleLikeSongUsecaseProvider);
    _toggleFavoritePlaylistUsecase = ref.read(toggleFavoritePlaylistUsecaseProvider);
    _addSongToPlaylistUsecase = ref.read(addSongToPlaylistUsecaseProvider);
    _deletePlaylistUsecase = ref.read(deletePlaylistUsecaseProvider);
    // repositories will be read directly where required to avoid nullable calls
    return const LibraryState();
  }

  void changeTab(LibraryTab tab) {
    state = state.copyWith(selectedTab: tab);
    if (tab == LibraryTab.songs && state.songs.isEmpty) {
      loadSongs();
    } else if (tab == LibraryTab.playlists && state.playlists.isEmpty) {
      loadPlaylists();
    }
  }

  void changePlaylistFilter(PlaylistFilter filter) {
    state = state.copyWith(playlistFilter: filter);
  }

  void changeSongGenre(String genre) {
    state = state.copyWith(selectedGenre: genre);
  }

  void clearSongFilters() {
    state = state.copyWith(
      selectedGenre: 'All',
      searchQuery: '',
    );
  }

  Future<void> loadSongs() async {
    state = state.copyWith(status: LibraryStatus.loading);

    final result = await _getAllSongsUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: LibraryStatus.error,
          errorMessage: failure.message,
        );
      },
      (songs) async {
        
        // Fetch user's liked songs once to avoid per-item network calls
        try {
          final repo = ref.read(songRepositoryProvider);
          final likedRes = await repo.getLikedSongs();
          final likedIds = <String>{};
          likedRes.fold((_) {
            
          }, (likedSongs) {
            for (var ls in likedSongs) {
              if (ls.id != null) likedIds.add(ls.id!);
            }
            
          });

          // Merge: prefer payload-provided isLiked, else mark true if present in likedIds, else fall back to per-item check
          final futures = songs.map((song) async {
            if (song.id == null) return song;

            if (song.isLiked != null) {
              return song;
            }

            if (likedIds.contains(song.id)) {
              return song.copyWith(isLiked: true);
            }

            // As a final fallback, call the per-item endpoint
            final res = await repo.checkIfLiked(song.id!);
            return res.fold((_) {
              return song;
            }, (liked) {
              return song.copyWith(isLiked: liked);
            });
          }).toList();

          final merged = await Future.wait(futures);
          state = state.copyWith(
            status: LibraryStatus.success,
            songs: merged,
          );
        } catch (e) {
          state = state.copyWith(
            status: LibraryStatus.success,
            songs: songs,
          );
        }
      },
    );
  }

  Future<void> loadPlaylists() async {
    state = state.copyWith(status: LibraryStatus.loading);
    

    final result = await _getAllPlaylistsUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: LibraryStatus.error,
          errorMessage: failure.message,
        );
      },
      (playlists) async {
        // Fetch user's favorited playlists once to avoid per-item calls
        try {
          final repo = ref.read(playlistRepositoryProvider);
          final favRes = await repo.getFavoritedPlaylists();
          final favIds = <String>{};
          favRes.fold((_) {
            
          }, (favPlaylists) {
            for (var p in favPlaylists) {
              if (p.id != null) favIds.add(p.id!);
            }
            
          });

          final futures = playlists.map((pl) async {
            if (pl.id == null) return pl;

            if (pl.isFavorited != null) {
              return pl;
            }

            if (favIds.contains(pl.id)) {
              return pl.copyWith(isFavorited: true);
            }

            // Final fallback: per-item check
            final res = await repo.checkIfFavorited(pl.id!);
            return res.fold((_) {
              return pl;
            }, (fav) {
              return pl.copyWith(isFavorited: fav);
            });
          }).toList();

          final merged = await Future.wait(futures);
          state = state.copyWith(
            status: LibraryStatus.success,
            playlists: merged,
          );
        } catch (e) {
          state = state.copyWith(
            status: LibraryStatus.success,
            playlists: playlists,
          );
        }
      },
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> loadUserPlaylistsForDropdown() async {
    // Load user playlists for the dropdown menu
    final result = await _getMyPlaylistsUsecase();

    result.fold(
      (failure) {
        // Silent fail - just keep empty list
      },
      (playlists) {
        state = state.copyWith(userPlaylists: playlists);
      },
    );
  }

  Future<void> refreshPlaylistCollections() async {
    await Future.wait([
      loadPlaylists(),
      loadUserPlaylistsForDropdown(),
    ]);
  }

  Future<void> toggleLikeSong(String songId) async {
    final params = ToggleLikeParams(songId: songId);
    final result = await _toggleLikeSongUsecase(params);

    result.fold(
      (failure) {
        // Show error
        state = state.copyWith(
          errorMessage: failure.message,
        );
      },
      (success) {
        // Update the song in the list
        final updatedSongs = state.songs.map((song) {
          if (song.id == songId) {
            return song.copyWith(
              isLiked: !(song.isLiked ?? false),
              likeCount: (song.isLiked ?? false) ? song.likeCount - 1 : song.likeCount + 1,
            );
          }
          return song;
        }).toList();

        state = state.copyWith(songs: updatedSongs);
      },
    );
  }

  Future<void> toggleFavoritePlaylist(String playlistId) async {
    final params = ToggleFavoriteParams(playlistId: playlistId);
    final result = await _toggleFavoritePlaylistUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: failure.message,
        );
      },
      (success) {
        // Update the playlist in the list
        final updatedPlaylists = state.playlists.map((playlist) {
          if (playlist.id == playlistId) {
            return playlist.copyWith(
              isFavorited: !(playlist.isFavorited ?? false),
              favoriteCount: (playlist.isFavorited ?? false)
                  ? playlist.favoriteCount - 1
                  : playlist.favoriteCount + 1,
            );
          }
          return playlist;
        }).toList();

        state = state.copyWith(playlists: updatedPlaylists);
      },
    );
  }

  Future<void> addSongToPlaylist(String songId, String playlistId) async {
    final params = AddSongToPlaylistParams(
      playlistId: playlistId,
      songId: songId,
    );
    final result = await _addSongToPlaylistUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: failure.message,
        );
      },
      (success) {
        // Success - could show a snackbar
        state = state.copyWith(
          errorMessage: null,
        );
      },
    );
  }

  Future<bool> deletePlaylist(String playlistId) async {
    final result = await _deletePlaylistUsecase(playlistId);

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (success) {
        final updatedPlaylists = state.playlists
            .where((playlist) => playlist.id != playlistId)
            .toList();
        final updatedUserPlaylists = state.userPlaylists
            .where((playlist) => playlist.id != playlistId)
            .toList();

        state = state.copyWith(
          playlists: updatedPlaylists,
          userPlaylists: updatedUserPlaylists,
          errorMessage: null,
        );
        return true;
      },
    );
  }

  Future<void> refreshData() async {
    if (state.selectedTab == LibraryTab.songs) {
      await loadSongs();
    } else {
      await loadPlaylists();
    }
  }
}
