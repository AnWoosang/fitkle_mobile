import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/group/presentation/providers/group_provider.dart';
import 'package:fitkle/features/group/presentation/widgets/group_card.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';

class MyGroupsSection extends ConsumerWidget {
  const MyGroupsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(groupProvider);

    // Mock: Show first 4 groups as "my groups"
    final myGroups = groupState.groups.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, myGroups.length),
        const SizedBox(height: 16),
        if (groupState.isLoading)
          _buildLoadingState()
        else if (myGroups.isNotEmpty)
          _buildGroupsGrid(context, myGroups)
        else
          _buildEmptyState(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, int groupCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.people, size: 20, color: AppTheme.primary),
            const SizedBox(width: 8),
            const Text(
              'My Groups',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '($groupCount)',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.push('/my-groups'),
          child: const Text(
            'View All',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildGroupsGrid(BuildContext context, List<GroupEntity> groups) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: groups.length,
      itemBuilder: (context, index) => _buildGroupCard(context, groups[index]),
    );
  }

  Widget _buildGroupCard(BuildContext context, GroupEntity group) {
    return GroupCard(
      group: group,
      size: GroupCardSize.small,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.mutedForeground.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.people,
              size: 24,
              color: AppTheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No groups yet',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              // TODO: Navigate to groups explore
              // context.push('/groups');
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.border),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Explore Groups',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
