import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/selectable_badge.dart';
import 'package:fitkle/shared/providers/toast_provider.dart';

/// A reusable modal widget for selecting items with category filtering support
/// Used for both Preferences and Interests selection
class SelectionModal extends ConsumerStatefulWidget {
  final String title;
  final List<String> selectedItems; // item names
  final List<Map<String, String>> allItems;
  final Function(List<String>) onSave;
  final String Function(String) getItemEmoji;
  final int maxSelection;
  final String categoryKey; // 'category' for interests, empty for preferences

  const SelectionModal({
    super.key,
    required this.title,
    required this.selectedItems,
    required this.allItems,
    required this.onSave,
    required this.getItemEmoji,
    this.maxSelection = 10,
    this.categoryKey = '',
  });

  @override
  ConsumerState<SelectionModal> createState() => _SelectionModalState();
}

class _SelectionModalState extends ConsumerState<SelectionModal> {
  late List<String> _selectedItems;
  late List<String> _initialItems;
  String _selectedCategory = 'CULTURE';

  // Category code to name mapping
  final Map<String, String> _categoryNames = {
    'CULTURE': 'Culture',
    'FOOD': 'Food',
    'CAREER': 'Career',
    'SPORTS': 'Sports',
    'ARTS': 'Arts',
    'WELLNESS': 'Wellness',
    'TRAVEL': 'Travel',
    'COMMUNITY': 'Community',
    'LEARNING': 'Learning',
    'ENTERTAINMENT': 'Entertainment',
  };

  final List<String> _categories = [
    'CULTURE',
    'FOOD',
    'CAREER',
    'SPORTS',
    'ARTS',
    'WELLNESS',
    'TRAVEL',
    'COMMUNITY',
    'LEARNING',
    'ENTERTAINMENT',
  ];

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
    _initialItems = List.from(widget.selectedItems);
  }

  // Get newly added items
  List<String> get _newlyAddedItems {
    return _selectedItems.where((item) => !_initialItems.contains(item)).toList();
  }

  List<Map<String, String>> get _filteredItems {
    if (widget.categoryKey.isEmpty) {
      // Preferences - no category filtering
      return widget.allItems;
    }

    // Interests - filter by category
    return widget.allItems.where((item) {
      final category = item[widget.categoryKey];
      return category == _selectedCategory;
    }).toList();
  }

  void _toggleItem(String itemName) {
    if (_selectedItems.contains(itemName)) {
      setState(() {
        _selectedItems.remove(itemName);
      });
    } else {
      if (_selectedItems.length < widget.maxSelection) {
        setState(() {
          _selectedItems.add(itemName);
        });
      } else {
        // Show toast when max selection reached
        ref.read(toastProvider.notifier).show(
          '최대 ${widget.maxSelection}개까지 추가할 수 있습니다.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
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
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    widget.onSave(_selectedItems);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    '완료',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // All selected items section
                    if (_selectedItems.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '선택된 태그',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_selectedItems.length}/${widget.maxSelection}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _selectedItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SelectableBadge(
                                emoji: widget.getItemEmoji(item),
                                label: item,
                                isSelected: true,
                                onTap: () => _toggleItem(item),
                                trailingIcon: Icons.close,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Newly added tags section
                    if (_newlyAddedItems.isNotEmpty) ...[
                      const Text(
                        '새로 추가한 태그',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _newlyAddedItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SelectableBadge(
                                emoji: widget.getItemEmoji(item),
                                label: item,
                                isSelected: true,
                                onTap: () => _toggleItem(item),
                                trailingIcon: Icons.close,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Add tags section title
                    const Text(
                      '추가할 태그',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category tabs (only for interests)
                    if (widget.categoryKey.isNotEmpty) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.map((category) {
                            final isSelected = _selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(_categoryNames[category] ?? category),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => _selectedCategory = category);
                                  }
                                },
                                selectedColor: AppTheme.primary,
                                backgroundColor: Colors.grey[100],
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppTheme.foreground,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                                side: BorderSide.none,
                                showCheckmark: false,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Available items
                    _filteredItems.where((item) {
                      final label = (item['label'] ?? item['name']) as String;
                      return !_selectedItems.contains(label);
                    }).isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'No items available',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.mutedForeground,
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _filteredItems.where((item) {
                              final label = (item['label'] ?? item['name']) as String;
                              return !_selectedItems.contains(label);
                            }).map((item) {
                              final label = (item['label'] ?? item['name']) as String;
                              final emoji = item['emoji'] as String;
                              return SelectableBadge(
                                emoji: emoji,
                                label: label,
                                isSelected: false,
                                onTap: () => _toggleItem(label),
                                trailingIcon: Icons.add,
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
