import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/event/presentation/widgets/event_card.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';
import 'package:fitkle/features/event/domain/entities/event_type.dart';

enum EventFilter {
  created,
  upcoming,
  past,
  saved,
}

class MyEventsListScreen extends StatefulWidget {
  final EventFilter initialFilter;

  const MyEventsListScreen({
    super.key,
    this.initialFilter = EventFilter.created,
  });

  @override
  State<MyEventsListScreen> createState() => _MyEventsListScreenState();
}

class _MyEventsListScreenState extends State<MyEventsListScreen> {
  late EventFilter selectedFilter;

  // Mock data - 실제로는 API에서 가져옴
  final List<EventEntity> upcomingEvents = [
    EventEntity(
      id: '1',
      title: 'Namsan Trail Running 🏔️',
      description: 'Join us for a morning trail run up Namsan Mountain',
      address: 'Namsan Mountain',
      datetime: DateTime(2025, 1, 18, 7, 0),
      attendees: 15,
      maxAttendees: 20,
      eventCategoryId: 'mock-category-id-sports',
      eventType: EventType.offline,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1551632811-561732d1e306',
      hostId: 'user1',
      hostName: 'Trail Runner',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    EventEntity(
      id: '2',
      title: '치맥 파티! 🍗🍺',
      description: 'Korean fried chicken and beer party',
      address: 'Hongdae',
      datetime: DateTime(2025, 1, 22, 19, 30),
      attendees: 24,
      maxAttendees: 30,
      eventCategoryId: 'mock-category-id-food',
      eventType: EventType.offline,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1562967916-eb82221dfb92',
      hostId: 'user1',
      hostName: 'Foodie',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<EventEntity> joinedUpcoming = [
    EventEntity(
      id: '3',
      title: 'Coffee Morning ☕',
      description: 'Weekend coffee and chat session',
      address: 'Gangnam Cafe',
      datetime: DateTime(2025, 1, 20, 10, 0),
      attendees: 12,
      maxAttendees: 15,
      eventCategoryId: 'mock-category-id-cafe',
      eventType: EventType.offline,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348',
      hostId: 'user2',
      hostName: 'Coffee Lover',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<EventEntity> joinedPast = [
    EventEntity(
      id: '4',
      title: 'K-Pop Dance Class 💃',
      description: 'Learn the latest K-Pop choreography',
      address: 'Hongdae Studio',
      datetime: DateTime(2024, 12, 15, 18, 0),
      attendees: 20,
      maxAttendees: 25,
      eventCategoryId: 'mock-category-id-culture',
      eventType: EventType.offline,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1504609813442-a8924e83f76e',
      hostId: 'user3',
      hostName: 'Dance Instructor',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<EventEntity> savedEvents = [
    EventEntity(
      id: '5',
      title: 'Language Exchange 🗣️',
      description: 'Practice Korean and English together',
      address: 'Itaewon Cafe',
      datetime: DateTime(2025, 1, 25, 19, 0),
      attendees: 16,
      maxAttendees: 20,
      eventCategoryId: 'mock-category-id-language',
      eventType: EventType.offline,
      thumbnailImageUrl: 'https://images.unsplash.com/photo-1543269865-cbf427effbad',
      hostId: 'user4',
      hostName: 'Language Teacher',
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
                        '내 이벤트',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '만든 것 ${upcomingEvents.length}개 · 참여 예정 ${joinedUpcoming.length}개',
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
                _buildTab('만든 것', EventFilter.created),
                const SizedBox(width: 8),
                _buildTab('참여 예정', EventFilter.upcoming),
                const SizedBox(width: 8),
                _buildTab('참여 완료', EventFilter.past),
                const SizedBox(width: 8),
                _buildTab('찜한 것', EventFilter.saved),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, EventFilter filter) {
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
    List<EventEntity> events;
    String emptyTitle;
    String emptyMessage;
    IconData emptyIcon;

    switch (selectedFilter) {
      case EventFilter.created:
        events = upcomingEvents;
        emptyTitle = '만든 이벤트가 없습니다';
        emptyMessage = '새로운 이벤트를 만들어보세요';
        emptyIcon = Icons.calendar_today;
        break;
      case EventFilter.upcoming:
        events = joinedUpcoming;
        emptyTitle = '참여 예정 이벤트가 없습니다';
        emptyMessage = '관심있는 이벤트에 참여해보세요';
        emptyIcon = Icons.calendar_today;
        break;
      case EventFilter.past:
        events = joinedPast;
        emptyTitle = '참여 완료한 이벤트가 없습니다';
        emptyMessage = '이벤트에 참여하고 추억을 쌓아보세요';
        emptyIcon = Icons.calendar_today;
        break;
      case EventFilter.saved:
        events = savedEvents;
        emptyTitle = '찜한 이벤트가 없습니다';
        emptyMessage = '관심있는 이벤트를 저장해보세요';
        emptyIcon = Icons.favorite_border;
        break;
    }

    if (events.isEmpty) {
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
                child: Icon(
                  emptyIcon,
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
        childAspectRatio: 0.68,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) => EventCard(
        event: events[index],
        type: EventCardType.vertical,
      ),
    );
  }
}
