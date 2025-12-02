import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// 선택 옵션의 스타일 타입
enum SelectableOptionStyle {
  /// 기본 스타일: 선택시 배경 없고 검은색 테두리와 검은색 컨텐츠
  defaultStyle,

  /// Primary 스타일: 선택시 Primary 테두리와 Primary 컨텐츠 (배경 없음)
  primary,
}

/// 공통 선택 가능한 옵션 버튼 컴포넌트
/// 성별, 카테고리 등의 선택지에서 사용
class SelectableOption extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final SelectableOptionStyle style;

  const SelectableOption({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.style = SelectableOptionStyle.defaultStyle,
  });

  @override
  Widget build(BuildContext context) {
    // 스타일에 따른 색상 결정
    final Color borderColor;
    final Color contentColor;
    final Color backgroundColor;

    if (style == SelectableOptionStyle.defaultStyle) {
      // 기본 스타일: 선택시 검은색, 미선택시 회색
      borderColor = isSelected ? Colors.black : AppTheme.border;
      contentColor = isSelected ? Colors.black : AppTheme.mutedForeground;
      backgroundColor = Colors.white;
    } else {
      // Primary 스타일: 선택시 Primary, 미선택시 회색 (배경 없음)
      borderColor = isSelected ? AppTheme.primary : AppTheme.border;
      contentColor = isSelected ? AppTheme.primary : AppTheme.mutedForeground;
      backgroundColor = Colors.white;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: contentColor,
                size: 24,
              ),
              const SizedBox(height: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
