import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/common/my_snack.dart';
import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/utils/responsive_utils.dart';
import 'package:weplay_music_streaming/features/artist/domain/usecases/update_artist_song_usecase.dart';
import 'package:weplay_music_streaming/features/user/domain/entities/song_entity.dart';

class EditSongModal extends ConsumerStatefulWidget {
  final SongEntity song;
  final void Function(SongEntity updated) onSave;

  const EditSongModal({super.key, required this.song, required this.onSave});

  @override
  ConsumerState<EditSongModal> createState() => _EditSongModalState();
}

class _EditSongModalState extends ConsumerState<EditSongModal> {
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
  late TextEditingController _titleCtrl;
  late String _selectedGenre;
  late String _selectedVisibility;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.song.title);
    _selectedGenre = widget.song.genre;
    _selectedVisibility = widget.song.visibility;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final usecase = ref.read(updateArtistSongUsecaseProvider);
    final result = await usecase(
      UpdateArtistSongParams(
        songId: widget.song.id ?? '',
        title: _titleCtrl.text.trim(),
        genre: _selectedGenre,
        visibility: _selectedVisibility,
      ),
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    result.fold(
      (failure) {
        MySnack.show(context, message: failure.message, icon: Icons.error_outline);
      },
      (updated) {
        widget.onSave(updated);
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
                Text('Edit Song', style: AppText.title),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                InputDecorator(
                  decoration: const InputDecoration(labelText: 'Genre'),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGenre,
                      isExpanded: true,
                      items: _genres
                          .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
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
                          .map((visibility) => DropdownMenuItem(value: visibility, child: Text(visibility)))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedVisibility = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel'))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        child: _isSaving
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Save'),
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
