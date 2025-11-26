import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class MyProfileAboutSection extends StatelessWidget {
  final String bio;

  const MyProfileAboutSection({
    super.key,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'About me',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              bio.isEmpty ? 'No bio yet.' : bio,
              style: TextStyle(
                fontSize: 14,
                color: bio.isEmpty
                    ? AppTheme.mutedForeground.withValues(alpha: 0.6)
                    : AppTheme.mutedForeground,
                height: 1.5,
                fontStyle: bio.isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
