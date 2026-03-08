import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/providers/artist_provider.dart';

class ArtistDetailsPopup extends ConsumerWidget {
  final String artistName;
  final String? artistId;

  const ArtistDetailsPopup._({required this.artistName, this.artistId});

  static Future<void> show(BuildContext context, {required String artistName, String? artistId}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ArtistDetailsPopup._(artistName: artistName, artistId: artistId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initials = (artistName.isNotEmpty ? artistName.trim().split(' ').map((s) => s.isNotEmpty ? s[0] : '').join() : '?').toUpperCase();
    final provider = ref.watch(artistProfileProvider(artistId));

    Widget avatarChild = CircleAvatar(radius: 44, child: Text(initials, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)));
    String bio = 'Artist bio not available.';

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 12),
            provider.when(
              data: (profile) {
                if (profile != null && profile.imageUrl != null && profile.imageUrl!.isNotEmpty) {
                  avatarChild = CircleAvatar(radius: 44, backgroundImage: NetworkImage(profile.imageUrl!));
                }
                bio = profile?.bio ?? bio;
                return avatarChild;
              },
              loading: () => avatarChild,
              error: (_, _) => avatarChild,
            ),
            const SizedBox(height: 12),
            Text(artistName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(bio, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
