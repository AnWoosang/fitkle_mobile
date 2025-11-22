import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/home/domain/entities/news_category.dart';

class NewsCategoryBreadcrumb extends StatelessWidget {
  final NewsCategory category;

  const NewsCategoryBreadcrumb({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'News > ${category.label}',
      style: const TextStyle(
        fontSize: 12,
        color: AppTheme.mutedForeground,
      ),
    );
  }
}
