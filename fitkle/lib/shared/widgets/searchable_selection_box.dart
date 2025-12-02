import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/search_field.dart';
import 'package:fitkle/shared/widgets/selectable_badge.dart';

/// Searchable selection box widget
///
/// A scrollable container with search field for selecting items with badges
class SearchableSelectionBox extends StatelessWidget {
  final String searchHint;
  final Function(String) onSearchChanged;
  final List<Map<String, String>> items;
  final Function(String) onItemTap;
  final String emptyTitle;
  final String emptyMessage;
  final double? maxHeight;

  const SearchableSelectionBox({
    super.key,
    required this.searchHint,
    required this.onSearchChanged,
    required this.items,
    required this.onItemTap,
    this.emptyTitle = 'No items found',
    this.emptyMessage = 'Try a different search term',
    this.maxHeight = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        SearchField(
          hintText: searchHint,
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 12),
        // Scrollable area with fixed height
        Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: maxHeight ?? 300),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppTheme.border, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: items.isNotEmpty
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items.map((item) {
                      final label = (item['label'] ?? item['name']) as String;
                      final emoji = item['emoji'] as String;
                      return SelectableBadge(
                        emoji: emoji,
                        label: label,
                        isSelected: false,
                        onTap: () => onItemTap(label),
                        trailingIcon: Icons.add,
                      );
                    }).toList(),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      children: [
                        const Icon(Icons.search, size: 64, color: AppTheme.mutedForeground),
                        const SizedBox(height: 16),
                        Text(
                          emptyTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          emptyMessage,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
