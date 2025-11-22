import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/sticky_header_bar.dart';
import 'package:fitkle/shared/widgets/buttons/detail_action_button.dart';
import 'package:fitkle/shared/widgets/detail/detail_screen_scroll_mixin.dart';
import 'package:fitkle/shared/widgets/detail/detail_screen_tab_bar_delegate.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';
import 'package:fitkle/features/event/domain/entities/event_type.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';
import 'package:fitkle/features/member/presentation/widgets/profile_header_banner.dart';
import 'package:fitkle/features/member/presentation/widgets/profile_about_section.dart';
import 'package:fitkle/features/member/presentation/widgets/profile_events_section.dart';
import 'package:fitkle/features/member/presentation/widgets/profile_groups_section.dart';

class MemberProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const MemberProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen>
    with SingleTickerProviderStateMixin, DetailScreenScrollMixin {

  @override
  int get tabCount => 3;

  @override
  void initState() {
    super.initState();
    initializeScrolling();
  }

  @override
  void dispose() {
    disposeScrolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mock user data
    final Map<String, dynamic> user = {
      'id': widget.userId,
      'name': widget.userName,
      'email': 'user@example.com',
      'username': 'user_handle',
      'location': 'Seoul, Gangnam',
      'attendanceRate': 92,
      'totalRSVPs': 17,
      'bio':
          '안녕하세요! 서울에서 다양한 활동을 즐기며 새로운 사람들을 만나는 것을 좋아합니다. 함께 즐거운 시간을 보내요! 😊',
      'interests': ['Social', 'Outdoors', 'Food & Dining', 'Culture', 'Sports'],
      'verified': true,
      'country': '🇰🇷',
      'countryName': 'South Korea',
    };

    // Mock hosted events
    final List<EventEntity> hostedEvents = List.generate(
      3,
      (index) => EventEntity(
        id: 'event-$index',
        title: 'Sample Event ${index + 1}',
        datetime: DateTime.now().add(Duration(days: index + 1)),
        address: 'Gangnam',
        attendees: 8 + index * 2,
        maxAttendees: 15,
        thumbnailImageUrl:
            'https://picsum.photos/seed/event-$index/400/400',
        eventCategoryId: 'mock-category-id-social',
        eventType: EventType.offline,
        description: 'Sample event description',
        hostName: widget.userName,
        hostId: widget.userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    // Mock joined groups
    final List<GroupEntity> joinedGroups = List.generate(
      4,
      (index) => GroupEntity(
        id: 'group-$index',
        name: 'Sample Group ${index + 1}',
        description: 'Sample group description',
        groupCategoryId: 'mock-category-id-social',
        totalMembers: 120 + (index * 30),
        thumbnailImageUrl:
            'https://picsum.photos/seed/group-$index/400/400',
        hostName: 'Host Name',
        hostId: 'host-id',
        eventCount: 5 + index,
        tags: ['tag1', 'tag2'],
        location: 'Seoul',
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          // Sticky Header Bar with Share Button
          StickyHeaderBar(
            title: '',
            actions: [
              DetailActionButton(
                icon: Icons.share,
                onPressed: () {
                  // TODO: Share functionality
                },
                showBackground: false,
              ),
            ],
          ),

          // Header Banner with Avatar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ProfileHeaderBanner(
                user: user,
                userName: widget.userName,
              ),
            ),
          ),

          // Sticky Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: DetailScreenTabBarDelegate(
              tabController: tabController,
              onTap: scrollToSection,
              tabLabels: const ['Profile', 'Events', 'Groups'],
            ),
          ),

          // About Section
          SliverToBoxAdapter(
            child: Container(
              key: sectionKeys[0],
              padding: const EdgeInsets.all(16),
              child: ProfileAboutSection(user: user),
            ),
          ),

          // Events Section
          SliverToBoxAdapter(
            child: Container(
              key: sectionKeys[1],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hosted Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfileEventsSection(hostedEvents: hostedEvents),
                ],
              ),
            ),
          ),

          // Groups Section
          SliverToBoxAdapter(
            child: Container(
              key: sectionKeys[2],
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Joined Groups',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ProfileGroupsSection(joinedGroups: joinedGroups),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
