import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class EventBottomButton extends StatelessWidget {
  final bool isFull;
  final int currentAttendees;
  final int maxAttendees;
  final VoidCallback? onPressed;

  const EventBottomButton({
    super.key,
    required this.isFull,
    required this.currentAttendees,
    required this.maxAttendees,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.background.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: AppTheme.border.withValues(alpha: 0.5),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton(
            onPressed: isFull ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFull ? AppTheme.muted : AppTheme.primary,
              foregroundColor: isFull ? AppTheme.mutedForeground : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              disabledBackgroundColor: AppTheme.muted,
              disabledForegroundColor: AppTheme.mutedForeground,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people, size: 20),
                const SizedBox(width: 8),
                Text(
                  isFull
                      ? 'Event Full ($currentAttendees/$maxAttendees)'
                      : 'Join Event ($currentAttendees/$maxAttendees)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
