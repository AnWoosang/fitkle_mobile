import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class HostCard extends StatelessWidget {
  final String? hostName;
  final String? hostCountry;
  final String? hostBio;
  final String? hostId;
  final int? eventsHosted;
  final int? totalGuests;
  final String? activeSince;

  const HostCard({
    super.key,
    this.hostName,
    this.hostCountry,
    this.hostBio,
    this.hostId,
    this.eventsHosted,
    this.totalGuests,
    this.activeSince,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = hostName ?? 'Jiyoung Park';
    final displayCountry = hostCountry ?? '🇰🇷';
    final displayBio = hostBio ?? 'Hello! I\'m Jiyoung living in Seoul for 3 years. I love spending enjoyable time with friends from different countries.';
    final displayEventsHosted = eventsHosted ?? 25;
    final displayTotalGuests = totalGuests ?? 150;
    final displayActiveSince = activeSince ?? '2 years';

    return InkWell(
      onTap: () {
        context.push('/user/${hostId ?? "1"}?userName=${Uri.encodeComponent(displayName)}');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.primary,
                      child: Text(
                        displayName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.background,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.foreground,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(displayCountry, style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              displayBio,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.muted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem('Events Hosted', displayEventsHosted.toString()),
                  ),
                  Container(width: 1, height: 32, color: AppTheme.border),
                  Expanded(
                    child: _buildStatItem('Total Guests', displayTotalGuests.toString()),
                  ),
                  Container(width: 1, height: 32, color: AppTheme.border),
                  Expanded(
                    child: _buildStatItem('Active Since', displayActiveSince),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.foreground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.mutedForeground,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
