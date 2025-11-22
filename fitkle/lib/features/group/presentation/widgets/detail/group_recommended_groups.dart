import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../features/group/presentation/widgets/group_card.dart';
import '../../providers/group_provider.dart';

class GroupRecommendedGroups extends ConsumerWidget {
  const GroupRecommendedGroups({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(groupProvider);
    final recommendedGroups = groupState.groups.take(9).toList();
    // Total items: 9 groups + 1 explore card = 10
    final totalItems = recommendedGroups.length + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recommended Groups',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.foreground,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: totalItems,
            itemBuilder: (context, index) {
              // Last item is the "Explore Groups" card
              if (index == recommendedGroups.length) {
                return _buildExploreCard(context);
              }

              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: GroupCard(
                  group: recommendedGroups[index],
                  size: GroupCardSize.small,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildExploreCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/groups'),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.explore,
                size: 28,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Explore Groups',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.foreground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              'Discover more',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
