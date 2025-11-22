import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class GroupPrivacySection extends StatelessWidget {
  final String privacy;
  final Function(String) onPrivacyChanged;

  const GroupPrivacySection({
    super.key,
    required this.privacy,
    required this.onPrivacyChanged,
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
                  child: Text('🔒', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '공개 설정',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          // Public Option
          InkWell(
            onTap: () => onPrivacyChanged('public'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: privacy == 'public' ? AppTheme.primary : AppTheme.border.withValues(alpha: 0.6),
                  width: privacy == 'public' ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: privacy == 'public' ? AppTheme.primary.withValues(alpha: 0.1) : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: privacy == 'public'
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primary.withValues(alpha: 0.2),
                                AppTheme.primary.withValues(alpha: 0.1),
                              ],
                            )
                          : null,
                      color: privacy != 'public' ? AppTheme.mutedForeground.withValues(alpha: 0.1) : null,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text('🌍', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '공개 그룹',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: privacy == 'public' ? AppTheme.primary : AppTheme.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '누구나 찾아서 가입할 수 있습니다',
                          style: TextStyle(fontSize: 12, color: AppTheme.mutedForeground),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Private Option
          InkWell(
            onTap: () => onPrivacyChanged('private'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: privacy == 'private' ? AppTheme.primary : AppTheme.border.withValues(alpha: 0.6),
                  width: privacy == 'private' ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: privacy == 'private' ? AppTheme.primary.withValues(alpha: 0.1) : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: privacy == 'private'
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primary.withValues(alpha: 0.2),
                                AppTheme.primary.withValues(alpha: 0.1),
                              ],
                            )
                          : null,
                      color: privacy != 'private' ? AppTheme.mutedForeground.withValues(alpha: 0.1) : null,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text('🔐', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '비공개 그룹',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: privacy == 'private' ? AppTheme.primary : AppTheme.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '승인된 회원만 가입할 수 있습니다',
                          style: TextStyle(fontSize: 12, color: AppTheme.mutedForeground),
                        ),
                      ],
                    ),
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
