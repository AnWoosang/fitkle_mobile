import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// 공통 선택 가능한 배지/칩 컴포넌트
/// Interest, Preference 등에서 사용
class SelectableBadge extends StatelessWidget {
  final String? emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? trailingIcon;
  final bool showBorder;
  final bool isNew;

  const SelectableBadge({
    super.key,
    this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.trailingIcon,
    this.showBorder = true,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    // isNew일 때는 회원가입 페이지처럼 더 강한 선택 효과
    // 설정 페이지에서 기존 선택된 항목(isSelected && !isNew)은 배경색 없음
    final backgroundColor = isNew
        ? AppTheme.primary.withValues(alpha: 0.15)
        : Colors.white;
    final borderColor = isNew
        ? AppTheme.primary
        : (isSelected ? AppTheme.primary.withValues(alpha: 0.3) : AppTheme.border);
    final borderWidth = isNew ? 2.0 : (isSelected ? 1.5 : 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: showBorder
              ? Border.all(
                  color: borderColor,
                  width: borderWidth,
                )
              : null,
          boxShadow: isNew
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(
                emoji!,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: (isSelected || isNew) ? FontWeight.w500 : FontWeight.w500,
                color: (isSelected || isNew) ? AppTheme.foreground : AppTheme.foreground,
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 4),
              Icon(
                trailingIcon,
                size: 14,
                color: (isSelected || isNew) ? AppTheme.foreground : AppTheme.mutedForeground,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
