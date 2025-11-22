import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/group_entity.dart';

class GroupTitleInfo extends StatelessWidget {
  final GroupEntity group;
  final bool isAppBarCollapsed;

  const GroupTitleInfo({
    super.key,
    required this.group,
    required this.isAppBarCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.foreground,
            ),
          ),
          const SizedBox(height: 16),
          // Stats in a single row with dots
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.people,
                    size: 16,
                    color: AppTheme.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${group.totalMembers} 멤버',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.mutedForeground,
                    ),
                  ),
                ],
              ),
              const Text(
                '•',
                style: TextStyle(
                  color: AppTheme.mutedForeground,
                  fontSize: 14,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${group.eventCount} 이벤트',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Location
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: 4),
              Text(
                group.location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
