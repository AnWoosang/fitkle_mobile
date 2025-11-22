import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class GroupLocationSection extends StatelessWidget {
  final String location;
  final VoidCallback onShowLocationDialog;

  const GroupLocationSection({
    super.key,
    required this.location,
    required this.onShowLocationDialog,
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.2),
                      AppTheme.primary.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('📍', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '위치',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: TextEditingController(text: location),
                  decoration: InputDecoration(
                    hintText: '시, 구를 검색하세요',
                    filled: true,
                    fillColor: AppTheme.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onTap: onShowLocationDialog,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onShowLocationDialog,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  minimumSize: const Size(0, 48),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, size: 16),
                    SizedBox(width: 8),
                    Text('검색'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📍', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '그룹의 주요 활동 지역을 선택하세요',
                  style: TextStyle(fontSize: 12, color: AppTheme.mutedForeground),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
