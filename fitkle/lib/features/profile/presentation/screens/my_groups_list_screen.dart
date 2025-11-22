import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/group/presentation/widgets/group_card.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';

enum GroupFilter {
  created,
  joined,
}

class MyGroupsListScreen extends StatefulWidget {
  final GroupFilter initialFilter;

  const MyGroupsListScreen({
    super.key,
    this.initialFilter = GroupFilter.created,
  });

  @override
  State<MyGroupsListScreen> createState() => _MyGroupsListScreenState();
}

class _MyGroupsListScreenState extends State<MyGroupsListScreen> {
  late GroupFilter selectedFilter;

  // Mock data - 실제로는 API에서 가져옴
  final List<GroupEntity> createdGroups = [
    GroupEntity(
      id: '1',
      name: 'Seoul Runners Club 🏃‍♂️',
      description: 'Running group for fitness enthusiasts in Seoul',
      groupCategoryId: 'mock-category-id-sports',
      totalMembers: 342,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5',
      hostName: 'Current User',
      hostId: 'user1',
      eventCount: 12,
      tags: ['running', 'fitness'],
      location: 'Seoul',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    GroupEntity(
      id: '2',
      name: 'Korean Language Exchange',
      description: 'Practice Korean with native speakers',
      groupCategoryId: 'mock-category-id-language',
      totalMembers: 156,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1',
      hostName: 'Current User',
      hostId: 'user1',
      eventCount: 8,
      tags: ['language', 'korean'],
      location: 'Gangnam',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    GroupEntity(
      id: '3',
      name: 'Photography Enthusiasts',
      description: 'Sharing photography tips and organizing photo walks',
      groupCategoryId: 'mock-category-id-culture',
      totalMembers: 89,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1452587925148-ce544e77e70d',
      hostName: 'Current User',
      hostId: 'user1',
      eventCount: 5,
      tags: ['photography', 'art'],
      location: 'Hongdae',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    GroupEntity(
      id: '4',
      name: 'Hiking Adventures',
      description: 'Exploring mountains and trails around Korea',
      groupCategoryId: 'mock-category-id-outdoor',
      totalMembers: 234,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1551632811-561732d1e306',
      hostName: 'Current User',
      hostId: 'user1',
      eventCount: 15,
      tags: ['hiking', 'outdoor'],
      location: 'Various',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<GroupEntity> joinedGroups = [
    GroupEntity(
      id: '5',
      name: 'Coffee & Chat Meetup',
      description: 'Casual coffee meetups for networking',
      groupCategoryId: 'mock-category-id-cafe',
      totalMembers: 123,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348',
      hostName: 'Other User',
      hostId: 'user2',
      eventCount: 20,
      tags: ['coffee', 'social'],
      location: 'Gangnam',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    GroupEntity(
      id: '6',
      name: 'Weekend Warriors',
      description: 'Weekend sports and fitness activities',
      groupCategoryId: 'mock-category-id-sports',
      totalMembers: 445,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438',
      hostName: 'Other User',
      hostId: 'user3',
      eventCount: 18,
      tags: ['sports', 'fitness'],
      location: 'Seoul',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    GroupEntity(
      id: '7',
      name: 'Book Club Korea',
      description: 'Monthly book discussions and literary events',
      groupCategoryId: 'mock-category-id-study',
      totalMembers: 67,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1507842217343-583bb7270b66',
      hostName: 'Other User',
      hostId: 'user4',
      eventCount: 6,
      tags: ['books', 'reading'],
      location: 'Itaewon',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    GroupEntity(
      id: '8',
      name: 'Tech Talks Seoul',
      description: 'Technology discussions and networking events',
      groupCategoryId: 'mock-category-id-tech',
      totalMembers: 892,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87',
      hostName: 'Other User',
      hostId: 'user5',
      eventCount: 25,
      tags: ['technology', 'networking'],
      location: 'Gangnam',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderWithTabs(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWithTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '내 그룹',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '만든 것 ${createdGroups.length}개 · 가입한 것 ${joinedGroups.length}개',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: AppTheme.border,
          ),
          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTab('만든 것', GroupFilter.created),
                const SizedBox(width: 8),
                _buildTab('가입한 것', GroupFilter.joined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, GroupFilter filter) {
    final isActive = selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.grey[800]! : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    List<GroupEntity> groups;
    String emptyTitle;
    String emptyMessage;

    switch (selectedFilter) {
      case GroupFilter.created:
        groups = createdGroups;
        emptyTitle = '만든 그룹이 없습니다';
        emptyMessage = '새로운 그룹을 만들어보세요';
        break;
      case GroupFilter.joined:
        groups = joinedGroups;
        emptyTitle = '가입한 그룹이 없습니다';
        emptyMessage = '관심사를 공유하는 사람들과 연결되세요';
        break;
    }

    if (groups.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.people,
                  size: 32,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                emptyMessage,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.61,
      ),
      itemCount: groups.length,
      itemBuilder: (context, index) => GroupCard(
        group: groups[index],
        size: GroupCardSize.small,
      ),
    );
  }
}
