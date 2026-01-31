import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_text.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_radius.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_spacing.dart';
import 'package:weplay_music_streaming/core/constants/app_constants/app_boxes.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/header/widgets/profile_stat.dart';
import 'package:weplay_music_streaming/features/profile/presentation/sections/header/widgets/image_source_bottom_sheet.dart';
import 'package:weplay_music_streaming/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:weplay_music_streaming/features/profile/presentation/state/profile_state.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  const ProfileHeader({super.key});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  String? _username;
  String? _email;
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload user data when the widget rebuilds (e.g., when navigating back)
    _loadUserData();
  }

  void _loadUserData() {
    final userSessionService = ref.read(userSessionServiceProvider);
    if (mounted) {
      setState(() {
        _username = userSessionService.getCurrentUserUsername() ?? 'User';
        _email = userSessionService.getCurrentUserEmail() ?? 'user@email.com';
        _profilePicture = userSessionService.getCurrentUserProfilePicture();
      });
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    
    // If already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    
    // Remove /api/ from base URL and remove leading slash from imagePath
    final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    
    return '$baseUrl/$cleanPath';
  }

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
        
        // Upload profile picture to backend
        await ref.read(profileViewModelProvider.notifier).updateUser(
          filePath: image.path,
        );
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
        
        // Upload profile picture to backend
        await ref.read(profileViewModelProvider.notifier).updateUser(
          filePath: image.path,
        );
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
    
    // Listen to profile state changes
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.status == ProfileStatus.success) {
        _loadUserData(); // Reload user data from session
        setState(() {
          _selectedImage = null; // Clear selected image to show network image
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (next.status == ProfileStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Failed to update profile picture'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    
    final profileState = ref.watch(profileViewModelProvider);
    final isLoading = profileState.status == ProfileStatus.loading;
    
    return Container(
      padding: AppSpacing.py8,
      color: surfaceColor,
      child: Column(
        children: [
          // Avatar
          GestureDetector(
            onTap: isLoading ? null : () => _showImageSourceOptions(context),
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
                      color: (_selectedImage != null || _profilePicture != null) 
                          ? Colors.transparent 
                          : primaryColor,
                      borderRadius: AppRadius.full,
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(File(_selectedImage!.path)),
                              fit: BoxFit.cover,
                            )
                          : _profilePicture != null && _profilePicture!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(_getFullImageUrl(_profilePicture)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    alignment: Alignment.center,
                    child: (_selectedImage == null && (_profilePicture == null || _profilePicture!.isEmpty))
                        ? Text(
                            _getInitials(_username ?? 'User'),
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
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: AppRadius.full,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.gap4,
          // Name
          Text(
            _username ?? 'User',
            style: AppText.headline.copyWith(
              color: textPrimary,
              fontSize: 20,
            ),
          ),
          AppSpacing.gap2,
          // Email
          Text(
            _email ?? 'user@email.com',
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
