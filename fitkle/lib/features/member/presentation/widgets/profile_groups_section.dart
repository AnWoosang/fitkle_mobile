import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/group/presentation/widgets/group_card.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';

/// User profile groups section showing joined groups with load more functionality
class ProfileGroupsSection extends StatefulWidget {
  final List<GroupEntity> joinedGroups;

  const ProfileGroupsSection({
    super.key,
    required this.joinedGroups,
  });

  @override
  State<ProfileGroupsSection> createState() => _ProfileGroupsSectionState();
}

class _ProfileGroupsSectionState extends State<ProfileGroupsSection> {
  late List<GroupEntity> _displayedGroups;

  @override
  void initState() {
    super.initState();
    _displayedGroups = List.from(widget.joinedGroups);
  }

  void _loadMore() {
    setState(() {
      // 기존 그룹 복제해서 추가 (실제로는 API 호출)
      final moreGroups = List<GroupEntity>.from(widget.joinedGroups);
      _displayedGroups.addAll(moreGroups);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.joinedGroups.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
        ),
        child: const Column(
          children: [
            Icon(Icons.people, size: 48, color: AppTheme.mutedForeground),
            SizedBox(height: 12),
            Text(
              'No joined groups',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: _displayedGroups.map((group) {
            return GroupCard(
              group: group,
              size: GroupCardSize.small,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _loadMore,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: AppTheme.border.withValues(alpha: 0.5),
              ),
            ),
            child: const Text(
              '더보기',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.foreground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
