import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:fitkle/features/member/presentation/providers/member_provider.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
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
    final memberAsync = ref.watch(currentMemberProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: memberAsync.when(
          data: (member) {
            print('========== MY PROFILE SCREEN ==========');
            print('[MyProfileScreen] member: $member');

            if (member == null) {
              print('[MyProfileScreen] member가 null입니다 - 로그인 필요');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('로그인이 필요합니다'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('로그인하기'),
                    ),
                  ],
                ),
              );
            }

            print('[MyProfileScreen] member 정보:');
            print('  - ID: ${member.id}');
            print('  - Email: ${member.email}');
            print('  - Nickname: ${member.nickname}');
            print('  - Location: ${member.location}');
            print('  - Nationality: ${member.nationality.name} (${member.nationality.code})');
            print('  - Gender: ${member.gender}');
            print('  - Bio: ${member.bio}');
            print('  - Interests: ${member.interests.length}개');
            for (var interest in member.interests) {
              print('    * ${interest.emoji} ${interest.nameKo} (${interest.code})');
            }
            print('  - Total RSVPs: ${member.totalRsvps}');
            print('  - Hosted Events: ${member.hostedEvents}');
            print('  - Attended Events: ${member.attendedEvents}');
            print('  - Social Handles:');
            print('    - Facebook: ${member.facebookHandle}');
            print('    - Instagram: ${member.instagramHandle}');
            print('    - Twitter: ${member.twitterHandle}');
            print('    - LinkedIn: ${member.linkedinHandle}');
            print('    - Email: ${member.emailHandle}');
            print('=======================================');

            // nationality에서 flag emoji와 이름 가져오기
            final countryFlag = member.nationality.flag;
            final countryName = member.nationality.name;

            // member 데이터를 profile Map으로 변환
            final profile = {
              'name': member.nickname ?? 'Unknown',
              'email': member.email,
              'location': member.location,
              'nationality': countryFlag,
              'nationalityFull': countryName,
              'bio': member.bio ?? '',
              'attendanceRate': 95, // TODO: 실제 출석률 계산
              'totalRSVPs': member.totalRsvps,
              'groups': 0, // TODO: 실제 그룹 수
              'interests': member.interests.length,
              'facebookHandle': member.facebookHandle,
              'instagramHandle': member.instagramHandle,
              'twitterHandle': member.twitterHandle,
              'linkedinHandle': member.linkedinHandle,
              'emailHandle': member.emailHandle,
            };

            // member interests를 문자열 리스트로 변환 (화면 표시용)
            final displayInterests = member.interests
                .map((interest) => '${interest.emoji} ${interest.nameEn}')
                .toList();

            return SingleChildScrollView(
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
                  MyProfileAboutSection(bio: profile['bio'] as String),
                  const SizedBox(height: 16),

                  // My Interests
                  MyProfileInterestsSection(
                    interests: displayInterests,
                    totalCount: member.interests.length,
                  ),
                  const SizedBox(height: 24),

                  // Section Divider
                  _buildSectionDivider(),
                  const SizedBox(height: 24),

                  // My Events Management
                  MyProfileEventsSection(
                    events: myCreatedEvents,
                    totalRSVPs: profile['totalRSVPs'] as int,
                  ),
                  const SizedBox(height: 16),

                  // My Groups Management
                  MyProfileGroupsSection(
                    groups: myCreatedGroups,
                    totalJoinedGroups: profile['groups'] as int,
                  ),
                  const SizedBox(height: 16),

                  // CTA Banner
                  _buildCTABanner(),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('오류가 발생했습니다: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(currentMemberProvider),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
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
