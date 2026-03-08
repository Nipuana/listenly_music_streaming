import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:weplay_music_streaming/common/my_snack.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/create_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class AddSongModal extends ConsumerStatefulWidget {
  final ValueChanged<SongEntity> onCreated;

  const AddSongModal({super.key, required this.onCreated});

  @override
  ConsumerState<AddSongModal> createState() => _AddSongModalState();
}

class _AddSongModalState extends ConsumerState<AddSongModal> {
  static const List<String> _genres = [
    'pop',
    'rock',
    'hip-hop',
    'electronic',
    'soul',
    'country',
    'jazz',
    'classical',
    'latin',
    'folk',
    'blues',
    'reggae',
    'metal',
    'gospel',
    'other',
  ];

  static const List<String> _visibilities = ['public', 'private', 'unlisted'];

  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _imagePicker = ImagePicker();

  String _selectedGenre = 'other';
  String _selectedVisibility = 'public';
  File? _audioFile;
  File? _coverImageFile;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['mp3', 'wav', 'm4a', 'aac', 'flac', 'ogg'],
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    setState(() {
      _audioFile = File(result.files.single.path!);
    });
  }

  Future<void> _pickCoverImage() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _coverImageFile = File(picked.path);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_audioFile == null) {
      MySnack.show(context, message: 'Please select an audio file', icon: Icons.error_outline);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final usecase = ref.read(createArtistSongUsecaseProvider);
    final result = await usecase(
      CreateArtistSongParams(
        title: _titleCtrl.text.trim(),
        genre: _selectedGenre,
        visibility: _selectedVisibility,
        audioFilePath: _audioFile!.path,
        coverImagePath: _coverImageFile?.path,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    result.fold(
      (failure) {
        MySnack.show(context, message: failure.message, icon: Icons.error_outline);
      },
      (song) {
        widget.onCreated(song);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Material(
        borderRadius: AppRadius.lg,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upload Song', style: AppText.title),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Title is required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                InputDecorator(
                  decoration: const InputDecoration(labelText: 'Genre'),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGenre,
                      isExpanded: true,
                      items: _genres
                          .map((genre) => DropdownMenuItem<String>(
                                value: genre,
                                child: Text(genre),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedGenre = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                InputDecorator(
                  decoration: const InputDecoration(labelText: 'Visibility'),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedVisibility,
                      isExpanded: true,
                      items: _visibilities
                          .map((visibility) => DropdownMenuItem<String>(
                                value: visibility,
                                child: Text(visibility),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedVisibility = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                OutlinedButton.icon(
                  onPressed: _pickAudioFile,
                  icon: const Icon(Icons.audio_file),
                  label: Text(_audioFile == null ? 'Choose audio file' : path.basename(_audioFile!.path)),
                ),
                if (_audioFile != null) ...[
                  const SizedBox(height: 6),
                  Text('Selected audio: ${path.basename(_audioFile!.path)}', style: AppText.body),
                ],
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                OutlinedButton.icon(
                  onPressed: _pickCoverImage,
                  icon: const Icon(Icons.image_outlined),
                  label: Text(_coverImageFile == null ? 'Choose cover image (optional)' : path.basename(_coverImageFile!.path)),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Upload'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
