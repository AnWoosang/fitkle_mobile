import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/member/domain/enums/country.dart';

class MyProfileStatsSection extends StatelessWidget {
  final Map<String, dynamic> profile;

  const MyProfileStatsSection({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bar_chart,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'My Stats',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Nationality (same design as other stat items)
            if (profile['nationalityEnum'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildNationalityItem(profile['nationalityEnum']),
              ),
            _buildStatItem(Icons.location_on, 'Location', profile['location'].replaceAll(',', ' /')),
            const SizedBox(height: 10),
            _buildStatItem(Icons.check_circle_outline, 'Attendance', '${profile['attendanceRate']}%'),
            const SizedBox(height: 10),
            _buildStatItem(Icons.check_circle, 'RSVP', '${profile['totalRSVPs']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildNationalityItem(Country country) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.muted.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.public,
            size: 16,
            color: Colors.pink.shade400,
          ),
          const SizedBox(width: 8),
          const Text(
            'Nationality',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.mutedForeground,
            ),
          ),
          const Spacer(),
          Text(
            country.nameEn,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            country.flag,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.muted.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.pink.shade400,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.mutedForeground,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
