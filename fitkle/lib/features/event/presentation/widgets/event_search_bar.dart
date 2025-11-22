import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/buttons/app_icon_button.dart';

class EventSearchBar extends StatelessWidget {
  final String searchQuery;
  final String selectedTab;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterPressed;

  const EventSearchBar({
    super.key,
    required this.searchQuery,
    required this.selectedTab,
    required this.onSearchChanged,
    required this.onFilterPressed,
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
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: selectedTab == 'groups' ? '그룹 검색' : '이벤트 검색',
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
                        onPressed: () => onSearchChanged(''),
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
              onPressed: onFilterPressed,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
