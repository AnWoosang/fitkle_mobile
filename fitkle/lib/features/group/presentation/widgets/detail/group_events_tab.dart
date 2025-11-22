import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../features/event/presentation/widgets/event_card.dart';
import '../../../../../shared/widgets/buttons/app_text_button.dart';
import '../../../../event/domain/entities/event_entity.dart';
import '../../../../event/domain/entities/event_type.dart';

class GroupEventsTab extends StatelessWidget {
  const GroupEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from GroupEntity
    final upcomingEvents = _getDummyUpcomingEvents();
    final pastEvents = _getDummyPastEvents();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildEventSection(
          title: 'Upcoming Events',
          count: upcomingEvents.length,
          events: upcomingEvents,
          onViewAll: () {
            // TODO: Navigate to upcoming events list
          },
        ),
        const SizedBox(height: 32),
        _buildEventSection(
          title: 'Past Events',
          count: pastEvents.length,
          events: pastEvents,
          onViewAll: () {
            // TODO: Navigate to past events list
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEventSection({
    required String title,
    required int count,
    required List<EventEntity> events,
    required VoidCallback onViewAll,
  }) {
    final hasMoreThan10 = count > 10;
    final displayEvents = events.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title ($count)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.foreground,
                ),
              ),
              if (hasMoreThan10)
                AppTextButton(
                  text: 'View all',
                  onPressed: onViewAll,
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (displayEvents.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'No ${title.toLowerCase()}',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          )
        else
          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: displayEvents.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < displayEvents.length - 1 ? 12 : 0,
                  ),
                  child: EventCard(
                    event: displayEvents[index],
                    type: EventCardType.vertical,
                    width: 180,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  // TODO: Remove dummy data when API is ready
  List<EventEntity> _getDummyUpcomingEvents() {
    return List.generate(
      12,
      (index) => EventEntity(
        id: 'upcoming-$index',
        title: 'Group Event ${index + 1}',
        datetime: DateTime(2025, (index % 12 + 1), 15, 18, 0),
        address: 'Gangnam',
        attendees: 25 + index * 5,
        maxAttendees: 50,
        thumbnailImageUrl: 'https://picsum.photos/seed/event-upcoming-$index/400/400',
        eventCategoryId: 'mock-category-id-social',
        eventType: EventType.offline,
        description: 'Join us for an exciting group event!',
        hostId: 'host-123',
        hostName: 'Group Host',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  List<EventEntity> _getDummyPastEvents() {
    return List.generate(
      8,
      (index) => EventEntity(
        id: 'past-$index',
        title: 'Past Group Event ${index + 1}',
        datetime: DateTime(2024, (index % 12 + 1), 15, 18, 0),
        address: 'Hongdae',
        attendees: 30 + index * 3,
        maxAttendees: 50,
        thumbnailImageUrl: 'https://picsum.photos/seed/event-past-$index/400/400',
        eventCategoryId: 'mock-category-id-social',
        eventType: EventType.offline,
        description: 'A memorable past group event.',
        hostId: 'host-123',
        hostName: 'Group Host',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }
}
