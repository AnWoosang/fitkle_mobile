import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/event/presentation/widgets/event_card.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';

/// User profile events section showing hosted events with load more functionality
class ProfileEventsSection extends StatefulWidget {
  final List<EventEntity> hostedEvents;

  const ProfileEventsSection({
    super.key,
    required this.hostedEvents,
  });

  @override
  State<ProfileEventsSection> createState() => _ProfileEventsSectionState();
}

class _ProfileEventsSectionState extends State<ProfileEventsSection> {
  late List<EventEntity> _displayedEvents;

  @override
  void initState() {
    super.initState();
    _displayedEvents = List.from(widget.hostedEvents);
  }

  void _loadMore() {
    setState(() {
      // 기존 이벤트 복제해서 추가 (실제로는 API 호출)
      final moreEvents = List<EventEntity>.from(widget.hostedEvents);
      _displayedEvents.addAll(moreEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hostedEvents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
        ),
        child: const Column(
          children: [
            Icon(Icons.calendar_today, size: 48, color: AppTheme.mutedForeground),
            SizedBox(height: 12),
            Text(
              'No hosted events',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ..._displayedEvents.map((event) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: EventCard(
              event: event,
              type: EventCardType.horizontal,
            ),
          );
        }),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _loadMore,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: AppTheme.border.withValues(alpha: 0.5),
              ),
            ),
            child: const Text(
              '더보기',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.foreground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
