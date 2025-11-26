import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/event/presentation/providers/event_provider.dart';
import 'package:fitkle/shared/widgets/detail/detail_screen_scroll_mixin.dart';
import 'package:fitkle/shared/widgets/detail/detail_screen_tab_bar_delegate.dart';
import 'package:fitkle/shared/widgets/detail/detail_screen_app_bar.dart';
import 'package:fitkle/features/event/presentation/widgets/detail/event_info_card.dart';
import 'package:fitkle/features/event/presentation/widgets/detail/event_details_tab.dart';
import 'package:fitkle/features/event/presentation/widgets/detail/event_photos_tab.dart';
import 'package:fitkle/features/event/presentation/widgets/detail/event_host_tab.dart';
import 'package:fitkle/features/event/presentation/widgets/detail/event_attendees_tab.dart';
import 'package:fitkle/features/event/presentation/widgets/detail/event_bottom_button.dart';
import 'package:fitkle/features/event/presentation/widgets/detail/event_slider_section.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen>
    with SingleTickerProviderStateMixin, DetailScreenScrollMixin {
  bool isLiked = false;

  @override
  int get tabCount => 4;

  @override
  void initState() {
    super.initState();
    initializeScrolling();
    // 조회수 증가 (세션당 한 번만)
    Future.microtask(() {
      ref
          .read(eventDetailProvider(widget.eventId).notifier)
          .incrementViewCount(widget.eventId);
    });
  }

  @override
  void dispose() {
    disposeScrolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventDetailProvider(widget.eventId));

    if (eventState.isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (eventState.errorMessage != null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Unable to load event',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  eventState.errorMessage!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final event = eventState.event;
    if (event == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: const SafeArea(
          child: Center(
            child: Text('Event not found'),
          ),
        ),
      );
    }

    // Mock data
    final List<String> eventPhotos = [
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=400',
      'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=400',
      'https://images.unsplash.com/photo-1543007630-9710e4a00a20?w=400',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
    ];

    final List<Map<String, dynamic>> attendees = [
      {'name': 'Sarah Kim', 'country': '🇰🇷'},
      {'name': 'Mike Johnson', 'country': '🇺🇸'},
      {'name': 'Yuki Tanaka', 'country': '🇯🇵'},
      {'name': 'Emma Wilson', 'country': '🇬🇧'},
      {'name': 'Li Wei', 'country': '🇨🇳'},
    ];

    // Get recommended and recently viewed events
    final allEventsState = ref.watch(eventProvider);
    final recommendedEvents = allEventsState.events.where((e) => e.id != event.id).take(5).toList();
    final recentlyViewedEvents = allEventsState.events.where((e) => e.id != event.id).take(5).toList();

    final isFull = event.attendees >= event.maxAttendees;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            slivers: [
              DetailScreenAppBar(
                headerContent: _buildHeaderImage(context, event),
                isCollapsed: isAppBarCollapsed,
                onBackPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                actions: [
                  DetailAppBarAction(
                    icon: Icons.share,
                    onPressed: () {},
                  ),
                  DetailAppBarAction(
                    icon: isLiked ? Icons.favorite : Icons.favorite_border,
                    onPressed: () {
                      setState(() => isLiked = !isLiked);
                    },
                    isActive: isLiked,
                    activeColor: Colors.red,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: _buildTitleAndInfoContent(event, isFull),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: DetailScreenTabBarDelegate(
                  tabController: tabController,
                  onTap: scrollToSection,
                  tabLabels: const ['Details', 'Photos', 'Host', 'Attendees'],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: sectionKeys[0],
                  child: EventDetailsTab(event: event),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: sectionKeys[1],
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      EventPhotosTab(eventPhotos: eventPhotos),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: sectionKeys[2],
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      EventHostTab(event: event),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: sectionKeys[3],
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      EventAttendeesTab(attendees: attendees),
                      const SizedBox(height: 32),
                      EventSliderSection(
                        title: '추천 이벤트',
                        events: recommendedEvents,
                      ),
                      const SizedBox(height: 32),
                      EventSliderSection(
                        title: '최근 본 이벤트',
                        events: recentlyViewedEvents,
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom Join Button
          EventBottomButton(
            isFull: isFull,
            currentAttendees: event.attendees,
            maxAttendees: event.maxAttendees,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context, dynamic event) {
    return SizedBox(
      height: 272,
      child: Stack(
        fit: StackFit.expand,
        children: [
          event.thumbnailImageUrl.isNotEmpty
              ? Image.network(
                  event.thumbnailImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.image, size: 64),
                    );
                  },
                )
              : Container(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.image, size: 64),
                ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndInfoContent(dynamic event, bool isFull) {
    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.foreground,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: EventInfoCard(
                  icon: Icons.calendar_today,
                  label: 'Date & Time',
                  value: DateFormat('yyyy-MM-dd HH:mm').format(event.datetime) + ' KST',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: EventInfoCard(
                  icon: Icons.people,
                  label: 'Attendees',
                  value: '${event.attendees} / ${event.maxAttendees}',
                  subValue: isFull
                      ? 'Full'
                      : '${event.maxAttendees - event.attendees} spots left',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          EventInfoCard(
            icon: Icons.location_on,
            label: 'Location',
            value: event.eventType.value == 'ONLINE' ? 'Online' : event.address,
            subValue: event.eventType.value == 'ONLINE'
                ? 'Meeting link will be shared after registration'
                : (event.detailAddress ?? 'Exact address will be revealed after registration'),
          ),
        ],
      ),
    );
  }
}
