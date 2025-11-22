import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class GroupPhotosTab extends StatelessWidget {
  const GroupPhotosTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from GroupEntity
    final groupPhotos = _getDummyPhotos();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Photos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.foreground,
            ),
          ),
          const SizedBox(height: 12),
          if (groupPhotos.isEmpty)
            const Text(
              'No photos yet',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: groupPhotos.length > 6 ? 6 : groupPhotos.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // TODO: Navigate to photo gallery view
                    if (index == 5 && groupPhotos.length > 6) {
                      // Show all photos
                    } else {
                      // Show single photo
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          groupPhotos[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              child: const Icon(Icons.image, size: 40),
                            );
                          },
                        ),
                        if (index == 5 && groupPhotos.length > 6)
                          Container(
                            color: Colors.black.withValues(alpha: 0.6),
                            child: Center(
                              child: Text(
                                '+${groupPhotos.length - 6}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // TODO: Remove dummy data when API is ready
  List<String> _getDummyPhotos() {
    return List.generate(
      15, // Total 15 photos to show +9 on 6th photo
      (index) => 'https://picsum.photos/seed/group-photo-$index/400/400',
    );
  }
}
