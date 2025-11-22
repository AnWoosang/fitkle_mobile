import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/core/utils/logger.dart';
import 'package:fitkle/features/event/domain/entities/event_category_entity.dart';
import 'package:fitkle/features/event/presentation/providers/event_provider.dart';

class EventTabSection extends ConsumerStatefulWidget {
  final String selectedTab;
  final String selectedCategory;
  final ValueChanged<String> onTabChanged;
  final ValueChanged<String> onCategoryChanged;

  const EventTabSection({
    super.key,
    required this.selectedTab,
    required this.selectedCategory,
    required this.onTabChanged,
    required this.onCategoryChanged,
  });

  @override
  ConsumerState<EventTabSection> createState() => _EventTabSectionState();
}

class _EventTabSectionState extends ConsumerState<EventTabSection> {
  List<EventCategoryEntity> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categoryService = ref.read(eventCategoryServiceProvider);
      final result = await categoryService.getCategories();

      result.fold(
        (failure) {
          Logger.error('Error loading categories: ${failure.message}', tag: 'EventTabSection');
          setState(() => _isLoading = false);
        },
        (categories) {
          // 'ALL' 카테고리 추가
          const allCategory = EventCategoryEntity(
            id: 'all',
            code: 'ALL',
            name: 'All',
            emoji: '🌟',
            sortOrder: 0,
          );

          setState(() {
            _categories = [allCategory, ...categories];
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      Logger.error('Error loading categories: $e', tag: 'EventTabSection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          // Sliding Pill Tabs
          Center(
            child: _SlidingPillTabs(
              selectedTab: widget.selectedTab,
              onTabChanged: widget.onTabChanged,
            ),
          ),
          const SizedBox(height: 12),
          // Category Tabs
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = widget.selectedCategory == category.code;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _CategoryChip(
                          emoji: category.emoji ?? '',
                          label: category.name,
                          isSelected: isSelected,
                          onTap: () => widget.onCategoryChanged(category.code),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }
}

// Sliding Pill Tabs (React-style) with flexible sizing
class _SlidingPillTabs extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabChanged;

  const _SlidingPillTabs({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // gray-100
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PillTabButton(
            label: '그룹 이벤트',
            isSelected: selectedTab == 'group-events',
            onTap: () => onTabChanged('group-events'),
          ),
          _PillTabButton(
            label: '개인 이벤트',
            isSelected: selectedTab == 'personal-events',
            onTap: () => onTabChanged('personal-events'),
          ),
        ],
      ),
    );
  }
}

class _PillTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PillTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1F2937) : Colors.transparent, // gray-900
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF374151), // gray-700
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6B7280) // gray-500
                : const Color(0xFFD1D5DB), // gray-300
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF1F2937) // gray-900
                    : const Color(0xFF4B5563), // gray-600
              ),
            ),
          ],
        ),
      ),
    );
  }
}
