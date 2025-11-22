import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/member/presentation/widgets/host_card.dart';

class EventHostTab extends StatelessWidget {
  final dynamic event;

  const EventHostTab({
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
            'Host',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.foreground,
            ),
          ),
          const SizedBox(height: 12),
          HostCard(
            hostName: event.hostName,
            hostId: '1',
          ),
        ],
      ),
    );
  }
}
