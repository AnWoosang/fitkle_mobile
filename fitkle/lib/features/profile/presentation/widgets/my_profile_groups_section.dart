import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/group/presentation/widgets/group_card.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';

class MyProfileGroupsSection extends StatefulWidget {
  final List<GroupEntity> groups;
  final int totalJoinedGroups;

  const MyProfileGroupsSection({
    super.key,
    required this.groups,
    required this.totalJoinedGroups,
  });

  @override
  State<MyProfileGroupsSection> createState() => _MyProfileGroupsSectionState();
}

class _MyProfileGroupsSectionState extends State<MyProfileGroupsSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.people,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'My Groups',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/my-groups');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primary,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: AppTheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Groups List
            if (widget.groups.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 255, // 그룹 카드 높이
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: (widget.groups.length / 2).ceil(), // 2개씩 묶어서 페이지 수 계산
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * 2;
                      final endIndex = (startIndex + 2).clamp(0, widget.groups.length);
                      final pageGroups = widget.groups.sublist(startIndex, endIndex);

                      return Row(
                        children: [
                          ...pageGroups.asMap().entries.map((entry) {
                            final index = entry.key;
                            final group = entry.value;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: index == 0 && pageGroups.length > 1 ? 12 : 0,
                                ),
                                child: GroupCard(
                                  group: group,
                                  size: GroupCardSize.small,
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Page Indicator
              if ((widget.groups.length / 2).ceil() > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      (widget.groups.length / 2).ceil(),
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.primary
                              : AppTheme.primary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 20),
            ] else
              _buildEmptyState(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.people,
              size: 40,
              color: AppTheme.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '아직 가입한 그룹이 없어요',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/events'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              '그룹 찾아보기',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
