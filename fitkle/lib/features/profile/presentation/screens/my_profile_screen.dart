import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';
import 'package:fitkle/features/event/domain/entities/event_type.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_header.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_stats_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_about_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_interests_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_events_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_groups_section.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final Map<String, dynamic> profile = {
    'name': 'Tony',
    'email': 'show19971002@gmail.com',
    'location': 'Seoul, KR',
    'nationality': '🇺🇸',
    'nationalityFull': 'United States',
    'bio': '안녕하세요! 서울에서 새로운 친구들을 만나고 다양한 활동을 즐기는 것을 좋아합니다. 카페 투어, 하이킹, 문화 체험 등 재미있는 것이라면 무엇이든 환영입니다! 😊',
    'attendanceRate': 95,
    'totalRSVPs': 19,
    'groups': 2,
    'interests': 6,
  };

  final List<String> myInterests = [
    'Social',
    'Outdoors',
    'New In Town',
    'Make New Friends',
    'Fun Times',
    'Social Networking'
  ];

  final List<EventEntity> myCreatedEvents = [
    EventEntity(
      id: '1',
      title: 'Weekend Tennis Match 🎾',
      datetime: DateTime.now().add(const Duration(days: 7)),
      address: 'Seoul',
      attendees: 3,
      maxAttendees: 10,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8',
      eventCategoryId: 'mock-category-id-sports',
      eventType: EventType.offline,
      description: 'Weekend tennis match',
      hostName: 'Tony',
      hostId: 'user-1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    EventEntity(
      id: '2',
      title: 'Morning Jog at Han River 🏃',
      datetime: DateTime.now().add(const Duration(days: 10)),
      address: 'Han River',
      attendees: 5,
      maxAttendees: 15,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1571008887538-b36bb32f4571',
      eventCategoryId: 'mock-category-id-sports',
      eventType: EventType.offline,
      description: 'Morning jog at Han River',
      hostName: 'Tony',
      hostId: 'user-1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<GroupEntity> myCreatedGroups = [
    GroupEntity(
      id: '1',
      name: 'Darklight_Seoul',
      description: 'Seoul social group',
      groupCategoryId: 'mock-category-id-social',
      totalMembers: 342,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30',
      hostName: 'Tony',
      hostId: 'user-1',
      eventCount: 5,
      tags: ['social'],
      location: 'Seoul',
    ),
    GroupEntity(
      id: '2',
      name: 'Seoul Social and Wellness Meetup',
      description: 'Wellness meetup group',
      groupCategoryId: 'mock-category-id-wellness',
      totalMembers: 156,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1511632765486-a01980e01a18',
      hostName: 'Tony',
      hostId: 'user-1',
      eventCount: 3,
      tags: ['wellness'],
      location: 'Seoul',
    ),
  ];

  void _showCopyToast(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label이(가) 복사되었습니다'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Banner with Avatar
              MyProfileHeader(
                profile: profile,
                onCopyToast: _showCopyToast,
              ),
              const SizedBox(height: 16),

              // Basic Info - Location & Stats
              MyProfileStatsSection(profile: profile),
              const SizedBox(height: 16),

              // About Me
              MyProfileAboutSection(bio: profile['bio']),
              const SizedBox(height: 16),

              // My Interests
              MyProfileInterestsSection(
                interests: myInterests,
                totalCount: profile['interests'],
              ),
              const SizedBox(height: 24),

              // Section Divider
              _buildSectionDivider(),
              const SizedBox(height: 24),

              // My Events Management
              MyProfileEventsSection(
                events: myCreatedEvents,
                totalRSVPs: profile['totalRSVPs'],
              ),
              const SizedBox(height: 16),

              // My Groups Management
              MyProfileGroupsSection(
                groups: myCreatedGroups,
                totalJoinedGroups: profile['groups'],
              ),
              const SizedBox(height: 16),

              // CTA Banner
              _buildCTABanner(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: AppTheme.border.withValues(alpha: 0.5)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'MANAGEMENT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.mutedForeground,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: AppTheme.border.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildCTABanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              '👋',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            const Text(
              'Find your people',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Join a new group near you and make meaningful connections!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/events'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Explore Groups',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
