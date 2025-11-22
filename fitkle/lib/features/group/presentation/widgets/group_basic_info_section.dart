import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class GroupBasicInfoSection extends StatelessWidget {
  final String name;
  final String description;
  final Function(String) onNameChanged;
  final Function(String) onDescriptionChanged;

  const GroupBasicInfoSection({
    super.key,
    required this.name,
    required this.description,
    required this.onNameChanged,
    required this.onDescriptionChanged,
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
                  child: Text('📝', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '기본 정보',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Group Name
          Row(
            children: [
              const Text(
                '그룹 이름',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: '예: Seoul International Friends ✨',
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
            validator: (value) => value?.isEmpty ?? true ? '그룹 이름을 입력해주세요' : null,
            onChanged: onNameChanged,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('💡', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '그룹의 목적을 반영하는 이름을 선택하세요',
                  style: TextStyle(fontSize: 12, color: AppTheme.mutedForeground),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description
          Row(
            children: [
              const Text(
                '설명',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: 6,
            decoration: InputDecoration(
              hintText: '그룹의 목적, 활동 내용, 어떤 사람들이 참여하면 좋을지 알려주세요... 💭',
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '설명을 입력해주세요';
              }
              if (value.length < 50) {
                return '최소 50자 이상 입력해주세요';
              }
              return null;
            },
            onChanged: onDescriptionChanged,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('✨', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '자세한 설명은 더 많은 멤버를 모을 수 있어요 (최소 50자)',
                  style: TextStyle(fontSize: 12, color: AppTheme.mutedForeground),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Group Image
          Row(
            children: [
              const Text(
                '그룹 이미지',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 6),
              const Text('📸', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              // TODO: Implement image upload
            },
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.border.withValues(alpha: 0.6),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primary.withValues(alpha: 0.1),
                          AppTheme.primary.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Center(
                      child: Text('🖼️', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '그룹 사진 업로드',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '권장: 1200x630px',
                    style: TextStyle(fontSize: 12, color: AppTheme.mutedForeground),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PNG, JPG, GIF (최대 5MB)',
                    style: TextStyle(fontSize: 12, color: AppTheme.mutedForeground),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
