import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/group_entity.dart';

class GroupHeaderImage extends StatelessWidget {
  final GroupEntity group;

  const GroupHeaderImage({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 272,
      child: Stack(
        fit: StackFit.expand,
        children: [
          group.thumbnailImageUrl.isNotEmpty
              ? Image.network(
                  group.thumbnailImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.image, size: 64),
                    );
                  },
                )
              : Container(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.image, size: 64),
                ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
