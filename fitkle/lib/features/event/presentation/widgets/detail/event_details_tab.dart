import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class EventDetailsTab extends StatelessWidget {
  final dynamic event;

  const EventDetailsTab({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.foreground,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            event.description ??
                'Start your weekend morning leisurely! Enjoy brunch at a cozy cafe near Gangnam Station while chatting with friends from various countries.\n\n'
                'You can casually talk about various topics such as life in Korea, travel, and hobbies. Those interested in learning Korean are also welcome!\n\n'
                'What to Prepare\n'
                '• Nothing special to prepare\n'
                '• Come in comfortable clothes\n\n'
                'Participation Fee\n'
                'Free (Individual payment for ordered food)',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.mutedForeground,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.foreground,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 48,
                    color: AppTheme.mutedForeground.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Map Loading...',
                    style: TextStyle(
                      color: AppTheme.mutedForeground.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
