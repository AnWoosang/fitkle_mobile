import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';

enum EventCardType { vertical, horizontal, list }

/// Common event card widget used throughout the app
/// Supports vertical (for sliders), horizontal (for compact lists), and list (for detailed lists) layouts
class EventCard extends StatelessWidget {
  final EventEntity event;
  final EventCardType type;
  final double? width;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.type = EventCardType.vertical,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case EventCardType.vertical:
        return _buildVerticalCard(context);
      case EventCardType.horizontal:
        return _buildHorizontalCard(context);
      case EventCardType.list:
        return _buildListCard(context);
    }
  }

  // Vertical card for Trending This Week slider
  Widget _buildVerticalCard(BuildContext context) {
    final cardWidth = width ?? 160.0; // Increased from 140 to 160

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: InkWell(
        onTap: () => context.go('/events/${event.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVerticalImage(cardWidth),
            Expanded(child: _buildVerticalInfo()),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalImage(double cardWidth) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(12),
      ),
      child: CachedNetworkImage(
        imageUrl: event.thumbnailImageUrl,
        width: cardWidth,
        height: cardWidth * 0.9, // Reduced from square (1.0) to 0.9
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppTheme.primary.withValues(alpha: 0.1),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppTheme.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.event, size: 40),
        ),
      ),
    );
  }

  Widget _buildVerticalInfo() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 12,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.eventType.value == 'ONLINE' ? 'Online' : event.address,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.people,
                size: 12,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${event.attendees} attending',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Horizontal card for Upcoming Events list
  Widget _buildHorizontalCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: InkWell(
        onTap: () => context.go('/events/${event.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHorizontalImage(),
              const SizedBox(width: 12),
              Expanded(child: _buildHorizontalInfo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: event.thumbnailImageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppTheme.primary.withValues(alpha: 0.1),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppTheme.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.event, size: 32),
        ),
      ),
    );
  }

  Widget _buildHorizontalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        _buildDateTimeRow(),
        const SizedBox(height: 4),
        _buildLocationRow(),
        const SizedBox(height: 4),
        _buildAttendeesRow(),
      ],
    );
  }

  Widget _buildDateTimeRow() {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 12, color: AppTheme.mutedForeground),
        const SizedBox(width: 4),
        Text(
          DateFormat('yyyy-MM-dd HH:mm').format(event.datetime),
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 12, color: AppTheme.mutedForeground),
        const SizedBox(width: 4),
        Text(
          event.eventType.value == 'ONLINE' ? 'Online' : event.address,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendeesRow() {
    return Row(
      children: [
        const Icon(Icons.people, size: 12, color: AppTheme.mutedForeground),
        const SizedBox(width: 4),
        Text(
          '${event.attendees}/${event.maxAttendees}',
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.mutedForeground,
          ),
        ),
      ],
    );
  }

  // List card for detailed event lists (from event feature)
  Widget _buildListCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap ?? () => context.go('/events/${event.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildListImage(),
            _buildListInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildListImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(16),
      ),
      child: event.thumbnailImageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: event.thumbnailImageUrl,
              height: 192,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 192,
                width: double.infinity,
                color: AppTheme.primary.withValues(alpha: 0.1),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 192,
                width: double.infinity,
                color: AppTheme.primary.withValues(alpha: 0.1),
                child: const Icon(Icons.image, size: 48),
              ),
            )
          : Container(
              height: 192,
              width: double.infinity,
              color: AppTheme.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.image, size: 48),
            ),
    );
  }

  Widget _buildListInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          _buildListMetadata(),
          const SizedBox(height: 12),
          Text(
            event.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.mutedForeground,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          _buildListFooter(),
        ],
      ),
    );
  }

  Widget _buildListMetadata() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today,
              size: 16,
              color: AppTheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              '${DateFormat('yyyy-MM-dd HH:mm').format(event.datetime)} KST',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on,
              size: 16,
              color: AppTheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              event.eventType.value == 'ONLINE' ? 'Online' : event.address,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListFooter() {
    return Row(
      children: [
        Text(
          'by ${event.hostName}',
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.mutedForeground,
          ),
        ),
        const SizedBox(width: 8),
        const Text('•', style: TextStyle(color: AppTheme.mutedForeground)),
        const SizedBox(width: 8),
        const Icon(
          Icons.people,
          size: 16,
          color: AppTheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          '${event.attendees}/${event.maxAttendees}',
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.mutedForeground,
          ),
        ),
      ],
    );
  }
}
