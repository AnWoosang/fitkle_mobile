import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class ProfileInterestsSection extends StatelessWidget {
  final List<String> interests;
  final int interestCount;

  const ProfileInterestsSection({
    super.key,
    required this.interests,
    required this.interestCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, size: 20, color: AppTheme.primary),
              const SizedBox(width: 8),
              const Text(
                'My interests ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '($interestCount)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.muted,
                      AppTheme.muted.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.border.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  interest,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.foreground,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
