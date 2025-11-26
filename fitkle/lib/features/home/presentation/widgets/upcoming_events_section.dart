import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/event/presentation/providers/event_provider.dart';
import 'package:fitkle/features/event/presentation/widgets/event_card.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';
import 'package:fitkle/features/auth/presentation/providers/auth_provider.dart';

class UpcomingEventsSection extends ConsumerStatefulWidget {
  const UpcomingEventsSection({super.key});

  @override
  ConsumerState<UpcomingEventsSection> createState() => _UpcomingEventsSectionState();
}

class _UpcomingEventsSectionState extends ConsumerState<UpcomingEventsSection> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  bool _isInitialized = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final upcomingState = ref.watch(upcomingEventsProvider);

    // 로그인된 사용자가 있으면 해당 멤버의 upcoming events 로드
    if (authState.isAuthenticated && authState.user != null && !_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(upcomingEventsProvider.notifier).loadUpcomingEvents(authState.user!.id);
        setState(() {
          _isInitialized = true;
        });
      });
    }

    final upcomingEvents = upcomingState.events.take(20).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        if (upcomingState.isLoading)
          _buildLoadingState()
        else if (upcomingEvents.isNotEmpty)
          _buildPageViewWithIndicator(context, upcomingEvents)
        else
          _buildEmptyState(),
      ],
    );
  }

  Widget _buildPageViewWithIndicator(BuildContext context, List<EventEntity> events) {
    // 2개씩 묶어서 페이지 구성
    final pageCount = (events.length / 2).ceil();

    return Column(
      children: [
        SizedBox(
          height: 240, // 카드 2개 (104 * 2) + 간격 (12) + 여유 (12)
          child: PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, pageIndex) {
              final firstIndex = pageIndex * 2;
              final secondIndex = firstIndex + 1;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    // 첫 번째 카드
                    EventCard(
                      event: events[firstIndex],
                      type: EventCardType.horizontal,
                    ),
                    const SizedBox(height: 12),
                    // 두 번째 카드 (있을 경우에만)
                    if (secondIndex < events.length)
                      EventCard(
                        event: events[secondIndex],
                        type: EventCardType.horizontal,
                      )
                    else
                      const SizedBox(height: 104), // 빈 공간 유지
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildPageIndicator(pageCount),
      ],
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    // 최대 표시할 점 개수 제한 (너무 많으면 보기 안좋음)
    final displayCount = pageCount > 10 ? 10 : pageCount;
    final showEllipsis = pageCount > 10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(displayCount, (index) {
          final isActive = index == _currentPage ||
              (showEllipsis && _currentPage >= displayCount && index == displayCount - 1);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primary : AppTheme.border,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
        if (showEllipsis) ...[
          const SizedBox(width: 4),
          Text(
            '+${pageCount - displayCount}',
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.mutedForeground,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 20, color: AppTheme.primary),
            const SizedBox(width: 8),
            const Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            context.push('/my-events?filter=upcoming');
          },
          child: const Text(
            'View all',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.calendar_today, size: 48, color: AppTheme.mutedForeground),
            SizedBox(height: 12),
            Text(
              'No upcoming events',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
