import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/buttons/app_icon_button.dart';

class GroupSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final VoidCallback onSearchSubmitted;
  final VoidCallback onClearPressed;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterPressed;

  const GroupSearchBar({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onSearchSubmitted,
    required this.onClearPressed,
    required this.onChanged,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: (_) => onSearchSubmitted(),
              decoration: InputDecoration(
                hintText: 'Search groups',
                hintStyle: const TextStyle(
                  color: AppTheme.mutedForeground,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: AppTheme.mutedForeground,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? AppIconButton(
                        icon: Icons.clear,
                        size: 16,
                        color: AppTheme.mutedForeground,
                        onPressed: onClearPressed,
                        padding: EdgeInsets.zero,
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.border.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.border.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.border.withValues(alpha: 0.5),
              ),
            ),
            child: AppIconButton(
              icon: Icons.tune,
              size: 20,
              color: AppTheme.mutedForeground,
              onPressed: onFilterPressed ?? () {},
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
