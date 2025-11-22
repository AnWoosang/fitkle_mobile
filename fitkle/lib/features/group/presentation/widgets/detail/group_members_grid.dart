import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/group_entity.dart';

class GroupMembersGrid extends StatelessWidget {
  final GroupEntity group;

  const GroupMembersGrid({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    final members = [
      {
        'name': 'John Doe',
        'initial': 'J',
        'color': const Color(0xFFEF4444).withValues(alpha: 0.8)
      },
      {
        'name': 'Sarah Kim',
        'initial': 'S',
        'color': const Color(0xFF3B82F6).withValues(alpha: 0.8)
      },
      {
        'name': 'Mike Lee',
        'initial': 'M',
        'color': const Color(0xFF10B981).withValues(alpha: 0.8)
      },
      {
        'name': 'Emily Park',
        'initial': 'E',
        'color': const Color(0xFFF59E0B).withValues(alpha: 0.8)
      },
      {
        'name': 'David Choi',
        'initial': 'D',
        'color': const Color(0xFF8B5CF6).withValues(alpha: 0.8)
      },
      {
        'name': 'Lisa Wang',
        'initial': 'L',
        'color': const Color(0xFFEC4899).withValues(alpha: 0.8)
      },
      {
        'name': 'Tom Brown',
        'initial': 'T',
        'color': const Color(0xFF06B6D4).withValues(alpha: 0.8)
      },
      {
        'name': 'Anna Lee',
        'initial': 'A',
        'color': const Color(0xFFF97316).withValues(alpha: 0.8)
      },
      {
        'name': 'Chris Park',
        'initial': 'C',
        'color': const Color(0xFF84CC16).withValues(alpha: 0.8)
      },
      {
        'name': 'Jane Kim',
        'initial': 'J',
        'color': const Color(0xFFA855F7).withValues(alpha: 0.8)
      },
      {
        'name': 'Alex Chen',
        'initial': 'A',
        'color': const Color(0xFF14B8A6).withValues(alpha: 0.8)
      },
      {
        'name': 'Ryan Park',
        'initial': 'R',
        'color': const Color(0xFFEF4444).withValues(alpha: 0.8)
      },
      {
        'name': 'Sophie Lee',
        'initial': 'S',
        'color': const Color(0xFF3B82F6).withValues(alpha: 0.8)
      },
      {
        'name': 'Kevin Jung',
        'initial': 'K',
        'color': const Color(0xFF10B981).withValues(alpha: 0.8)
      },
      {
        'name': 'Nina Choi',
        'initial': 'N',
        'color': const Color(0xFFF59E0B).withValues(alpha: 0.8)
      },
    ];

    final itemCount = group.totalMembers > 11
        ? 12
        : (members.length < group.totalMembers ? members.length : group.totalMembers);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Members (${group.totalMembers})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.foreground,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == 11 && group.totalMembers > 11) {
                return Column(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.muted,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '+${group.totalMembers - 11}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.foreground,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '더보기',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.mutedForeground,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              }

              final member = members[index];
              return Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: member['color'] as Color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            member['initial'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    member['name'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.foreground,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
