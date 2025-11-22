import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/core/utils/logger.dart';
import 'package:fitkle/features/group/domain/entities/group_category_entity.dart';
import 'package:fitkle/features/group/presentation/providers/group_provider.dart';

class GroupCategoryTabs extends ConsumerStatefulWidget {
  final String selectedCategoryCode;
  final ValueChanged<String> onCategoryChanged;

  const GroupCategoryTabs({
    super.key,
    required this.selectedCategoryCode,
    required this.onCategoryChanged,
  });

  @override
  ConsumerState<GroupCategoryTabs> createState() => _GroupCategoryTabsState();
}

class _GroupCategoryTabsState extends ConsumerState<GroupCategoryTabs> {
  List<GroupCategoryEntity> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categoryService = ref.read(groupCategoryServiceProvider);
      final result = await categoryService.getCategories();

      result.fold(
        (failure) {
          Logger.error('Error loading categories: ${failure.message}', tag: 'GroupCategoryTabs');
          setState(() => _isLoading = false);
        },
        (categories) {
          // 'ALL' 카테고리 추가
          const allCategory = GroupCategoryEntity(
            id: 'all',
            code: 'all',
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
      Logger.error('Error loading categories: $e', tag: 'GroupCategoryTabs');
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
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = widget.selectedCategoryCode == category.code;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => widget.onCategoryChanged(category.code),
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
                              category.emoji ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              category.name,
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
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
