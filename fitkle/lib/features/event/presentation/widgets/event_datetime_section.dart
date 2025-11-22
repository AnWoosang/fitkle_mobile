import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class EventDateTimeSection extends StatelessWidget {
  final bool isRecurring;
  final Function(bool) onRecurringChanged;

  const EventDateTimeSection({
    super.key,
    required this.isRecurring,
    required this.onRecurringChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🗓️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text(
                '날짜 및 시간',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDateField()),
              const SizedBox(width: 8),
              Expanded(child: _buildTimeField()),
            ],
          ),
          const SizedBox(height: 12),
          _buildRecurringCheckbox(),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '날짜',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'YYYY-MM-DD',
            hintStyle: const TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
            filled: true,
            fillColor: AppTheme.background,
            prefixIcon: const Icon(Icons.calendar_today, size: 14, color: AppTheme.mutedForeground),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '시간',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'HH:MM',
            hintStyle: const TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
            filled: true,
            fillColor: AppTheme.background,
            prefixIcon: const Icon(Icons.access_time, size: 14, color: AppTheme.mutedForeground),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurringCheckbox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRecurring
            ? AppTheme.primary.withValues(alpha: 0.1)
            : AppTheme.muted.withValues(alpha: 0.2),
        border: Border.all(
          color: isRecurring
              ? AppTheme.primary.withValues(alpha: 0.3)
              : AppTheme.border.withValues(alpha: 0.4),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isRecurring,
            onChanged: (value) => onRecurringChanged(value!),
            activeColor: AppTheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('🔄', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text(
                      '매주 반복 이벤트',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '매주 같은 요일, 같은 시간에 자동 생성',
                  style: TextStyle(fontSize: 10, color: AppTheme.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
