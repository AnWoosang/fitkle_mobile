import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/event/presentation/providers/event_provider.dart';
import 'package:fitkle/features/event/presentation/widgets/event_card.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';

class TrendingSection extends ConsumerWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventProvider);
    final trendingEvents = eventState.events.skip(4).take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        if (eventState.isLoading)
          _buildLoadingState()
        else if (trendingEvents.isNotEmpty)
          _buildEventList(context, trendingEvents),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.trending_up, size: 20, color: AppTheme.primary),
        const SizedBox(width: 8),
        const Text(
          'Trending This Week',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
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

  Widget _buildEventList(BuildContext context, List<EventEntity> events) {
    return SizedBox(
      height: 260, // Adjusted to match reduced image size
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < events.length - 1 ? 12 : 0,
            ),
            child: EventCard(
              event: event,
              type: EventCardType.vertical,
              width: 160, // Increased from 140 to show 3rd event partially
            ),
          );
        },
      ),
    );
  }
}
