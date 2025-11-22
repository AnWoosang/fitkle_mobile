import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class EventAttendeesTab extends StatelessWidget {
  final List<Map<String, dynamic>> attendees;

  const EventAttendeesTab({
    super.key,
    required this.attendees,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attendees',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.foreground,
            ),
          ),
          const SizedBox(height: 12),
          // Floating Circles Animation Placeholder
          SizedBox(
            height: 320,
            width: double.infinity,
            child: Center(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: attendees.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final attendee = entry.value;

                    // Position avatars in a circle
                    final angle = (idx / attendees.length) * 2 * math.pi;
                    final radius = 100.0;
                    final x = radius * math.cos(angle);
                    final y = radius * math.sin(angle);

                    return Positioned(
                      left: 160 + x - 28,
                      top: 160 + y - 28,
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.background,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 28,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                Positioned(
                                  bottom: -2,
                                  right: -2,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: AppTheme.background,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.border,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        attendee['country'],
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 80),
                            child: Text(
                              attendee['name'],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
