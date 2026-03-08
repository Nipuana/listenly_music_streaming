import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/common/my_snack.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class PlaybarManager extends ChangeNotifier {
  PlaybarManager._() {
    _init();
  }
  static final PlaybarManager instance = PlaybarManager._();
  final AudioPlayer _player = AudioPlayer();

  SongEntity? _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  List<SongEntity> _queue = const [];
  int _currentIndex = 0;
  // play window (FIFO) containing up to 3 entries: [previous?, current, next?]
  final List<SongEntity> _window = [];
  // actual playback history (LIFO) so Previous returns the last played song
  final List<SongEntity> _history = [];
  // recent songs (FIFO) containing up to 10 recently played songs
  final List<SongEntity> _recentSongs = [];
  bool _shuffle = true; // next in queue should be random by default
  bool _repeatOne = false;
  bool _overlayVisible = false;
  bool _handlingCompletion = false;

  static const _prefsKey = 'playbar_audio_allowed';
  static const _recentSongsKey = 'recent_songs';
  static const _recentSongsDateKey = 'recent_songs_date';
  static const _storage = FlutterSecureStorage();
  bool _audioAllowed = false;

  SongEntity? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  List<SongEntity> get queue => _queue;
  int get currentIndex => _currentIndex;
  bool get overlayVisible => _overlayVisible;

  List<SongEntity> get window => _window;
  List<SongEntity> get recentSongs => List.unmodifiable(_recentSongs);

  bool get audioAllowed => _audioAllowed;

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _player.playerStateStream.listen((state) {
      final playing = state.playing && state.processingState != ProcessingState.completed;
      _isPlaying = playing;
      notifyListeners();
    });

    _player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _player.durationStream.listen((d) {
      _duration = d ?? Duration.zero;
      notifyListeners();
    });
    _player.playbackEventStream.listen((event) {
      // handle completion
      if (event.processingState == ProcessingState.completed) {
        if (_handlingCompletion) return;
        _handlingCompletion = true;

        if (_repeatOne) {
          // defer seek/play to avoid firing stream events synchronously
          Future.microtask(() async {
            try {
              await _player.seek(Duration.zero);
              await _player.play();
            } catch (_) {}
            _handlingCompletion = false;
          });
          return;
        }

        // otherwise move to next in queue; defer to avoid re-entrancy
        Future.microtask(() async {
          try {
            next();
          } catch (_) {}
          _handlingCompletion = false;
        });
      }
    }, onError: (e) {
      // errors handled silently
    });
    _player.playbackEventStream.handleError((e) {
      // errors handled silently
    });
    // load persisted audio permission
    try {
      final prefs = await SharedPreferences.getInstance();
      _audioAllowed = prefs.getBool(_prefsKey) ?? false;
    } catch (_) {
      _audioAllowed = false;
    }

    // load recent songs from secure storage
    await _loadRecentSongs();
  }

  Future<void> _loadRecentSongs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = _todayDateString();
      final savedDate = prefs.getString(_recentSongsDateKey);

      // Different calendar day → wipe persisted list so UI starts fresh
      if (savedDate != today) {
        await _storage.delete(key: _recentSongsKey);
        await prefs.remove(_recentSongsDateKey);
        _recentSongs.clear();
        notifyListeners();
        return;
      }

      final jsonString = await _storage.read(key: _recentSongsKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _recentSongs.clear();
        _recentSongs.addAll(
          jsonList.map((json) => SongEntity.fromJson(json as Map<String, dynamic>)).toList(),
        );
      }
    } catch (e) {
      // If loading fails, just start with empty list
    }
  }

  Future<void> _saveRecentSongs() async {
    try {
      final jsonList = _recentSongs.map((song) => song.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _storage.write(key: _recentSongsKey, value: jsonString);
      // Update the date stamp so the daily check knows when this was last written
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_recentSongsDateKey, _todayDateString());
    } catch (e) {
      // If saving fails, continue silently
    }
  }

  /// Clears recently played songs from memory and persistent storage.
  /// Called on logout and automatically on the first load of a new calendar day.
  Future<void> clearRecentSongs() async {
    _recentSongs.clear();
    notifyListeners();
    try {
      await _storage.delete(key: _recentSongsKey);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentSongsDateKey);
    } catch (_) {}
  }

  /// Returns today's date as a compact string (e.g. '2026-03-08').
  String _todayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void _addToRecentSongs(SongEntity song) {
    // Remove if already exists to avoid duplicates
    _recentSongs.removeWhere((s) => s.id == song.id);
    
    // Add to the end (most recent)
    _recentSongs.add(song);
    
    // Keep only last 10 songs (FIFO - remove oldest if exceeds 10)
    if (_recentSongs.length > 10) {
      _recentSongs.removeAt(0);
    }
    
    // Save to storage
    _saveRecentSongs();
  }

  void setQueue(List<SongEntity> songs, {int startIndex = 0}) {
    final idx = (startIndex < 0 || startIndex >= songs.length) ? 0 : startIndex;
    final song = songs.isNotEmpty ? songs[idx] : null;
    _queue = List<SongEntity>.from(songs);
    _currentIndex = idx;
    _currentSong = song;
    _duration = Duration(seconds: song?.duration ?? 0);
    _buildWindow();
    notifyListeners();
  }

  void addToQueue(SongEntity song) {
    _queue = List<SongEntity>.from(_queue)..add(song);
    notifyListeners();
  }

  void enqueueList(List<SongEntity> songs) {
    _queue = List<SongEntity>.from(_queue)..addAll(songs);
    notifyListeners();
  }

  void clearQueue() {
    _queue = [];
    _currentIndex = 0;
    _currentSong = null;
    _window.clear();
    notifyListeners();
  }

  Future<void> playSongAt(int index, {bool recordHistory = true}) async {
    if (index < 0 || index >= _queue.length) return;
    final song = _queue[index];
    if (song.audioUrl == null || song.audioUrl!.isEmpty) return;

    // Record the currently playing song into history so Previous goes back
    if (recordHistory && _currentSong != null) {
      try {
        _history.add(_currentSong!);
        if (_history.length > 100) _history.removeAt(0);
      } catch (_) {}
    }

    _currentIndex = index;
    _currentSong = song;
    _position = Duration.zero;
    _duration = Duration(seconds: song.duration ?? 0);
    _buildWindow();

    // Add to recent songs
    _addToRecentSongs(song);

    try {
      // activate audio session before playback
      try {
        final session = await AudioSession.instance;
        await session.setActive(true);
      } catch (_) {}
      final url = _getFullAudioUrl(song.audioUrl!);
      final storage = const FlutterSecureStorage();
      const tokenKey = 'auth_token';
      final token = await storage.read(key: tokenKey);
      final accessible = await _checkUrlAccessible(url, token: token);

      // Attempt to include Authorization header if we have a token
      var setSucceeded = false;
      try {
        if (token != null && token.isNotEmpty) {
          final src = AudioSource.uri(
            Uri.parse(url),
            headers: {'Authorization': 'Bearer $token'},
          );
          await _player.setAudioSource(src);
        } else {
          await _player.setUrl(url);
        }
        setSucceeded = true;
      } catch (error) {
        debugPrint('Failed to set remote audio source: $error');
      }

      // If setting the remote source failed or URL not accessible, try download fallback
      if (!setSucceeded || !accessible) {
        try {
          final uri = Uri.parse(url);
          final client = HttpClient();
          if (token != null && token.isNotEmpty) {
            client.addCredentials(uri, 'basic', HttpClientBasicCredentials('', token));
          }
          final req = await client.getUrl(uri);
          if (token != null && token.isNotEmpty) {
            req.headers.set('Authorization', 'Bearer $token');
          }
          final resp = await req.close();
          if (resp.statusCode == 200) {
            final bytes = await consolidateHttpClientResponseBytes(resp);
            final dir = await getTemporaryDirectory();
            final file = File('${dir.path}/${uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'audio.tmp'}');
            await file.writeAsBytes(bytes, flush: true);
            await _player.setFilePath(file.path);
          } else {
          }
          client.close(force: true);
        } catch (error) {
          debugPrint('Failed to cache audio locally: $error');
        }
      }

      try {
        await _player.play();
      } catch (error) {
        debugPrint('Failed to start playback: $error');
      }
    } catch (error) {
      debugPrint('Unexpected playback failure: $error');
    }
    notifyListeners();
  }

  Future<bool> _checkUrlAccessible(String url, {String? token}) async {
    try {
      final uri = Uri.parse(url);
      final client = HttpClient();
      try {
        final req = await client.headUrl(uri).timeout(const Duration(seconds: 5));
        if (token != null && token.isNotEmpty) {
          req.headers.set('Authorization', 'Bearer $token');
        }
        final resp = await req.close().timeout(const Duration(seconds: 5));
        client.close(force: true);
        return resp.statusCode >= 200 && resp.statusCode < 400;
      } catch (_) {
        // HEAD failed, try GET
        try {
          final req2 = await client.getUrl(uri).timeout(const Duration(seconds: 5));
          if (token != null && token.isNotEmpty) {
            req2.headers.set('Authorization', 'Bearer $token');
          }
          final resp2 = await req2.close().timeout(const Duration(seconds: 5));
          client.close(force: true);
          return resp2.statusCode >= 200 && resp2.statusCode < 400;
        } catch (e2) {
          client.close(force: true);
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  void play() {
    try {
      _player.play();
    } catch (_) {}
  }

  void pause() {
    try {
      _player.pause();
    } catch (_) {}
  }

  void togglePlayPause() {
    try {
      if (_player.playing) {
        _player.pause();
      } else {
        _player.play();
      }
    } catch (_) {}
  }

  void next() {
    if (_queue.isEmpty) return;
    if (_shuffle && _queue.length > 1) {
      final rand = Random();
      var nextIndex = _currentIndex;
      for (var i = 0; i < 10 && nextIndex == _currentIndex; i++) {
        nextIndex = rand.nextInt(_queue.length);
      }
      if (nextIndex == _currentIndex) {
        nextIndex = (_currentIndex + 1) % _queue.length;
      }
      playSongAt(nextIndex);
      return;
    }
    final nextIndex = _currentIndex + 1;
    if (nextIndex >= _queue.length) return;
    playSongAt(nextIndex);
  }

  void previous([BuildContext? context]) {
    // Prefer actual playback history (last-played) so Previous returns the exact song
    if (_history.isNotEmpty) {
      final prevSong = _history.removeLast();
      final prevIndex = _queue.indexWhere((s) => s.id == prevSong.id);
      if (prevIndex != -1) {
        playSongAt(prevIndex, recordHistory: false);
        return;
      }
      // If the previous song is not in the current queue, play it directly
      setQueue([prevSong], startIndex: 0);
      awaitPlayFirstInQueue();
      return;
    }

    final prev = _currentIndex - 1;
    if (prev >= 0) {
      playSongAt(prev, recordHistory: false);
      return;
    }

    if (context != null) {
      try {
        MySnack.show(
          context,
          message: 'No previous track',
          icon: Icons.skip_previous,
        );
      } catch (_) {}
    }
  }

  // helper to play the first item in the current queue without recording history
  void awaitPlayFirstInQueue() {
    if (_queue.isEmpty) return;
    playSongAt(0, recordHistory: false);
  }

  void _buildWindow() {
    _window.clear();
    // previous
    if (_currentIndex - 1 >= 0 && _currentIndex - 1 < _queue.length) {
      _window.add(_queue[_currentIndex - 1]);
    }
    // current
    if (_currentIndex >= 0 && _currentIndex < _queue.length) {
      _window.add(_queue[_currentIndex]);
    }
    // next
    if (_currentIndex + 1 >= 0 && _currentIndex + 1 < _queue.length) {
      _window.add(_queue[_currentIndex + 1]);
    }
    // cap to 3
    while (_window.length > 3) {
      _window.removeAt(0);
    }
  }

  void setShuffle(bool enabled) {
    _shuffle = enabled;
    notifyListeners();
  }

  bool get isShuffle => _shuffle;

  bool get isRepeatOne => _repeatOne;

  void toggleRepeatOne() {
    _repeatOne = !_repeatOne;
    notifyListeners();
  }

  void seek(Duration position) {
    try {
      _player.seek(position);
    } catch (_) {}
  }

  void toggleOverlay() {
    _overlayVisible = !_overlayVisible;
    notifyListeners();
  }

  Future<bool> ensureAudioAllowed(BuildContext context) async {
    if (_audioAllowed) return true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getBool(_prefsKey) ?? false;
      if (stored) {
        _audioAllowed = true;
        return true;
      }
    } catch (_) {}

    if (!context.mounted) {
      return false;
    }

    final allow = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Allow audio'),
        content: const Text('Allow app to play audio through speakers?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Deny')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Allow')),
        ],
      ),
    );

    final granted = allow == true;
    _audioAllowed = granted;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, granted);
    } catch (_) {}
    return granted;
  }

  String _getFullAudioUrl(String? audioPath) {
    if (audioPath == null || audioPath.isEmpty) return '';
    if (audioPath.startsWith('http://') || audioPath.startsWith('https://')) {
      return audioPath;
    }
    final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
    final cleanPath = audioPath.startsWith('/') ? audioPath.substring(1) : audioPath;
    return '$baseUrl/$cleanPath';
  }
}
