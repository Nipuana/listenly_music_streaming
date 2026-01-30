import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_boxes.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/header/widgets/profile_stat.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/header/widgets/image_source_bottom_sheet.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  void _showPermissionDialog(BuildContext context, String permissionType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required', style: AppText.bodyMedium),
        content: Text(
          'This app needs permission to access your $permissionType to update your profile picture.',
          style: AppText.small,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: AppText.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text(
              'Open Settings',
              style: AppText.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final status = await Permission.photos.request();
    
    if (status.isGranted) {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
        });
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDialog(context, 'photos');
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final status = await Permission.camera.request();
    
    if (status.isGranted) {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
        });
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDialog(context, 'camera');
      }
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ImageSourceBottomSheet(
        onCameraTap: () {
          Navigator.pop(context);
          _pickImageFromCamera();
        },
        onGalleryTap: () {
          Navigator.pop(context);
          _pickImageFromGallery();
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = theme.cardColor;
    final primaryColor = theme.colorScheme.primary;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final cardShadow = isDark ? AppBoxes.darkCardShadow : AppBoxes.cardShadow;
    return Container(
      padding: AppSpacing.py8,
      color: surfaceColor,
      child: Column(
        children: [
          // Avatar
          GestureDetector(
            onTap: () => _showImageSourceOptions(context),
            child: Stack(
              children: [
                Container(
                  width: AppSpacing.size20,
                  height: AppSpacing.size20,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.full,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                      width: 3,
                    ),
                    boxShadow: [
                      cardShadow,
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedImage != null ? Colors.transparent : primaryColor,
                      borderRadius: AppRadius.full,
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(File(_selectedImage!.path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: _selectedImage == null
                        ? Text(
                            'JD',
                            style: AppText.headline.copyWith(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: surfaceColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gap4,
          // Name
          Text(
            'John Doe',
            style: AppText.headline.copyWith(
              color: textPrimary,
              fontSize: 20,
            ),
          ),
          AppSpacing.gap2,
          // Email
          Text(
            'john.doe@email.com',
            style: AppText.body.copyWith(
              color: textSecondary,
              fontSize: 14,
            ),
          ),
          AppSpacing.gap6,
          // Stats Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileStat(count: '125', label: 'Liked Songs'),
              ProfileStat(count: '8', label: 'Playlists'),
              ProfileStat(count: '45', label: 'Following'),
            ],
          ),
        ],
      ),
    );
  }
}
