import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class EventLocationSection extends StatelessWidget {
  final String locationType;
  final Function(String) onLocationTypeChanged;
  final Function(String) onLocationChanged;
  final Function(String) onDetailedAddressChanged;
  final Function(String) onOnlineLinkChanged;

  const EventLocationSection({
    super.key,
    required this.locationType,
    required this.onLocationTypeChanged,
    required this.onLocationChanged,
    required this.onDetailedAddressChanged,
    required this.onOnlineLinkChanged,
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
              const Text('📍', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text(
                '장소 정보',
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
              const Text(
                '모임 방식',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildLocationTypeButton(
                  '📍',
                  '오프라인',
                  locationType == 'offline',
                  () => onLocationTypeChanged('offline'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLocationTypeButton(
                  '💻',
                  '온라인',
                  locationType == 'online',
                  () => onLocationTypeChanged('online'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (locationType == 'offline') _buildOfflineLocation(),
          if (locationType == 'online') _buildOnlineLocation(),
        ],
      ),
    );
  }

  Widget _buildLocationTypeButton(String emoji, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border.withValues(alpha: 0.6),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors.transparent,
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary.withValues(alpha: 0.2)
                    : AppTheme.muted.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: '도로명 주소',
          hint: '주소를 검색하세요',
          required: true,
          onChanged: onLocationChanged,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: '상세 주소',
          hint: '예: 2층 스타벅스, 101호',
          onChanged: onDetailedAddressChanged,
        ),
      ],
    );
  }

  Widget _buildOnlineLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: '온라인 링크',
          hint: '예: https://zoom.us/j/123456789',
          required: true,
          onChanged: onOnlineLinkChanged,
        ),
        const SizedBox(height: 6),
        Row(
          children: const [
            Text('💡', style: TextStyle(fontSize: 12)),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Zoom, Google Meet 등의 링크를 입력하세요',
                style: TextStyle(fontSize: 10, color: AppTheme.mutedForeground),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    bool required = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
