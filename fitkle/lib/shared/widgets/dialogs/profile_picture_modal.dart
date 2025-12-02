import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// Profile picture change modal with options to take photo, choose from gallery, or remove photo
class ProfilePictureModal extends StatelessWidget {
  final bool hasCurrentPhoto;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseFromGallery;
  final VoidCallback? onRemovePhoto;

  const ProfilePictureModal({
    super.key,
    required this.hasCurrentPhoto,
    required this.onTakePhoto,
    required this.onChooseFromGallery,
    this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Change Profile Picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Options
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildOption(
                  context: context,
                  icon: Icons.camera_alt,
                  title: 'Take Photo',
                  onTap: () {
                    Navigator.of(context).pop();
                    onTakePhoto();
                  },
                ),
                const SizedBox(height: 12),
                _buildOption(
                  context: context,
                  icon: Icons.photo_library,
                  title: 'Choose from Gallery',
                  onTap: () {
                    Navigator.of(context).pop();
                    onChooseFromGallery();
                  },
                ),
                if (hasCurrentPhoto && onRemovePhoto != null) ...[
                  const SizedBox(height: 12),
                  _buildOption(
                    context: context,
                    icon: Icons.delete_outline,
                    title: 'Remove Photo',
                    onTap: () {
                      Navigator.of(context).pop();
                      onRemovePhoto!();
                    },
                    isDestructive: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withValues(alpha: 0.05) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive ? Colors.red.withValues(alpha: 0.2) : AppTheme.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive ? Colors.red.withValues(alpha: 0.1) : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : AppTheme.foreground,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDestructive ? Colors.red : AppTheme.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
