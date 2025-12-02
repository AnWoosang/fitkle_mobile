import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_header.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_stats_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_about_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_interests_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_events_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/my_profile_groups_section.dart';
import 'package:fitkle/features/member/presentation/providers/member_provider.dart';
import 'package:fitkle/features/event/presentation/providers/event_provider.dart';
import 'package:fitkle/features/group/presentation/providers/group_provider.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load events and groups when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final memberAsync = ref.read(currentMemberProvider);
      memberAsync.whenData((member) {
        if (member != null) {
          // Load upcoming events
          ref.read(upcomingEventsProvider.notifier).loadUpcomingEvents(member.id);
          // Load my groups
          ref.read(myGroupsProvider.notifier).loadMyGroups(member.id);
        }
      });
    });
  }

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
              print('    * ${interest.emoji} ${interest.name} (${interest.code})');
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
            final countryName = member.nationality.nameEn;

            // member 데이터를 profile Map으로 변환
            final profile = {
              'name': member.nickname ?? 'Unknown',
              'email': member.email,
              'location': member.location,
              'nationality': countryFlag,
              'nationalityFull': countryName,
              'nationalityEnum': member.nationality,
              'gender': member.gender?.nameEn,
              'bio': member.bio ?? '',
              'avatarUrl': member.avatarUrl,
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
                .map((interest) => '${interest.emoji} ${interest.name}')
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
                  Consumer(
                    builder: (context, ref, child) {
                      final upcomingEventsState = ref.watch(upcomingEventsProvider);
                      return MyProfileEventsSection(
                        events: upcomingEventsState.events,
                        totalRSVPs: profile['totalRSVPs'] as int,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // My Groups Management
                  Consumer(
                    builder: (context, ref, child) {
                      final myGroupsState = ref.watch(myGroupsProvider);
                      return MyProfileGroupsSection(
                        groups: myGroupsState.groups,
                        totalJoinedGroups: myGroupsState.groups.length,
                      );
                    },
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
