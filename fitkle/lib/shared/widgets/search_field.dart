import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// 검색 필드의 스타일 타입
enum SearchFieldStyle {
  /// 기본 스타일: 포커싱시 검은색 테두리, 검은색 커서
  defaultStyle,

  /// Primary 스타일: 포커싱시 Primary 테두리, Primary 커서
  primary,
}

/// 공통 검색 입력 필드 컴포넌트
class SearchField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final SearchFieldStyle style;
  final TextEditingController? controller;

  const SearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.style = SearchFieldStyle.defaultStyle,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // 스타일에 따른 색상 결정
    final Color focusBorderColor;
    final Color cursorColor;
    final Color selectionColor;

    if (style == SearchFieldStyle.defaultStyle) {
      focusBorderColor = Colors.black;
      cursorColor = Colors.black;
      selectionColor = Colors.grey.withValues(alpha: 0.3);
    } else {
      focusBorderColor = AppTheme.primary;
      cursorColor = AppTheme.primary;
      selectionColor = AppTheme.primary.withValues(alpha: 0.3);
    }

    return SelectionArea(
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: cursorColor,
            selectionColor: selectionColor,
            selectionHandleColor: cursorColor,
          ),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          cursorColor: cursorColor,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppTheme.mutedForeground,
            ),
            suffixIcon: const Icon(Icons.search, size: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: focusBorderColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
