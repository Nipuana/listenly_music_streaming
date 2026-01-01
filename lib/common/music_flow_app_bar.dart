import 'package:flutter/material.dart';
import '../core/constants/app_constants/app_colors.dart';

class MusicFlowAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuTap;

  const MusicFlowAppBar({
    super.key,
    required this.title,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.music_note, color: AppColors.primary),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black54),
          onPressed: onMenuTap ?? () {},
        ),
      ],
    );
  }
}
