import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../features/member/presentation/widgets/host_card.dart';
import '../../../domain/entities/group_entity.dart';
import 'group_members_grid.dart';

class GroupAboutTab extends StatelessWidget {
  final GroupEntity group;

  const GroupAboutTab({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.foreground,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            group.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.mutedForeground,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 27),
          // Host Section
          const Text(
            'Host',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.foreground,
            ),
          ),
          const SizedBox(height: 15),
          HostCard(
            hostName: group.hostName,
            hostId: '1',
            eventsHosted: group.eventCount,
          ),
          const SizedBox(height: 27),
          // Members Section
          GroupMembersGrid(group: group),
        ],
      ),
    );
  }
}
