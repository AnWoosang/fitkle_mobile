import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';
import 'package:fitkle/features/group/presentation/providers/group_provider.dart';
import 'package:fitkle/features/group/presentation/widgets/group_card.dart';

class GroupListView extends StatelessWidget {
  final ScrollController scrollController;
  final GroupState groupState;
  final List<GroupEntity> groups;
  final VoidCallback onRetry;
  final Function(GroupEntity) onGroupTap;

  const GroupListView({
    super.key,
    required this.scrollController,
    required this.groupState,
    required this.groups,
    required this.onRetry,
    required this.onGroupTap,
  });

  @override
  Widget build(BuildContext context) {
    if (groupState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (groupState.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppTheme.mutedForeground),
            const SizedBox(height: 16),
            Text(
              groupState.errorMessage!,
              style: const TextStyle(color: AppTheme.mutedForeground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.groups_outlined, size: 64, color: AppTheme.mutedForeground),
            const SizedBox(height: 16),
            const Text(
              'No groups found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          sliver: SliverToBoxAdapter(
            child: Text(
              '${groups.length} groups',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => GroupCard(
                group: groups[index],
                onTap: () => onGroupTap(groups[index]),
              ),
              childCount: groups.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}
