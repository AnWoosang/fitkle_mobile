import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class EventBasicInfoSection extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final List<Map<String, String>> categories;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;
  final Function(String) onCategoryChanged;

  const EventBasicInfoSection({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.categories,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onCategoryChanged,
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
              const Text('📝', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text(
                '기본 정보',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: '이벤트 제목',
            hint: '예: 강남 브런치 모임 ☕',
            required: true,
            onChanged: onTitleChanged,
          ),
          const SizedBox(height: 12),
          _buildTextArea(
            label: '설명',
            hint: '어떤 이벤트인지 알려주세요...',
            required: true,
            onChanged: onDescriptionChanged,
          ),
          const SizedBox(height: 12),
          _buildCategorySelection(),
          const SizedBox(height: 12),
          _buildImageUpload(),
        ],
      ),
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

  Widget _buildTextArea({
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
          maxLines: 4,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '카테고리',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final isSelected = category == cat['name'];
            return GestureDetector(
              onTap: () => onCategoryChanged(cat['name']!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.border.withValues(alpha: 0.6),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cat['emoji']!, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      cat['name']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? AppTheme.primary : AppTheme.foreground,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '이벤트 이미지',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 6),
            const Text('📸', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.border.withValues(alpha: 0.6),
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primary,
                child: Text('🖼️', style: TextStyle(fontSize: 24)),
              ),
              SizedBox(height: 8),
              Text(
                '이미지 업로드',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                '권장: 1200x630px',
                style: TextStyle(fontSize: 10, color: AppTheme.mutedForeground),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
