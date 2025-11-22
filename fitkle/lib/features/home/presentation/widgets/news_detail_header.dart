import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/home/domain/entities/news.dart';

class NewsDetailHeader extends StatelessWidget {
  final News news;

  const NewsDetailHeader({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    if (news.thumbnailImageUrl == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.muted.withValues(alpha: 0.3),
                  AppTheme.muted.withValues(alpha: 0.6),
                ],
              ),
            ),
            child: Image.network(
              news.thumbnailImageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.article, size: 64, color: AppTheme.primary),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
