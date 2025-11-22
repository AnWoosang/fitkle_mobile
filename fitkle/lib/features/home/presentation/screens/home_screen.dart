import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/footer.dart';
import 'package:fitkle/features/event/presentation/providers/event_provider.dart';
import 'package:fitkle/features/group/presentation/providers/group_provider.dart';
import 'package:fitkle/features/home/presentation/providers/news_provider.dart';
import 'package:fitkle/features/home/presentation/widgets/upcoming_events_section.dart';
import 'package:fitkle/features/home/presentation/widgets/my_groups_section.dart';
import 'package:fitkle/features/home/presentation/widgets/trending_section.dart';
import 'package:fitkle/features/home/presentation/widgets/news_section.dart';
import 'package:fitkle/shared/widgets/app_logo.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(eventProvider.notifier).loadEvents();
      ref.read(groupProvider.notifier).loadGroups();
      ref.read(newsProvider.notifier).loadNews();
    });
  }

  /// Pull-to-refresh 핸들러
  Future<void> _onRefresh() async {
    // 모든 데이터 강제 새로고침 (캐시 무시)
    await Future.wait([
      ref.read(eventProvider.notifier).loadEvents(forceRefresh: true),
      ref.read(groupProvider.notifier).loadGroups(forceRefresh: true),
      ref.read(newsProvider.notifier).loadNews(forceRefresh: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Pull-to-refresh가 항상 동작하도록
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 24),
                  const UpcomingEventsSection(),
                  const SizedBox(height: 24),
                  const MyGroupsSection(),
                  const SizedBox(height: 24),
                  const TrendingSection(),
                  const SizedBox(height: 24),
                  const NewsSection(),
                  const SizedBox(height: 24),
                  const Footer(),
                  const SizedBox(height: 100), // Bottom navigation bar 공간
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const Center(
      child: AppLogo(compact: true),
    );
  }
}
