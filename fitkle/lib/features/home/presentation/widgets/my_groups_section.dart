import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/group/presentation/providers/group_provider.dart';
import 'package:fitkle/features/group/presentation/widgets/group_card.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';
import 'package:fitkle/features/auth/presentation/providers/auth_provider.dart';

class MyGroupsSection extends ConsumerStatefulWidget {
  const MyGroupsSection({super.key});

  @override
  ConsumerState<MyGroupsSection> createState() => _MyGroupsSectionState();
}

class _MyGroupsSectionState extends ConsumerState<MyGroupsSection> {
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final myGroupsState = ref.watch(myGroupsProvider);

    // 로그인된 사용자가 있으면 해당 멤버의 그룹 로드
    if (authState.isAuthenticated && authState.user != null && !_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(myGroupsProvider.notifier).loadMyGroups(authState.user!.id);
        setState(() {
          _isInitialized = true;
        });
      });
    }

    // 최대 20개 그룹 표시
    final myGroups = myGroupsState.groups.take(20).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        if (myGroupsState.isLoading)
          _buildLoadingState()
        else if (myGroups.isNotEmpty)
          _buildGroupsList(context, myGroups)
        else
          _buildEmptyState(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Icon(Icons.people, size: 20, color: AppTheme.primary),
            SizedBox(width: 8),
            Text(
              'My Groups',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
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

  Widget _buildGroupsList(BuildContext context, List<GroupEntity> groups) {
    return SizedBox(
      height: 254, // GroupCard small 높이 + 여유
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < groups.length - 1 ? 12 : 0,
            ),
            child: GroupCard(
              group: groups[index],
              size: GroupCardSize.small,
              width: 160, // Trending This Week와 동일한 너비
            ),
          );
        },
      ),
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
