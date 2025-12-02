import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// 공통 텍스트 입력 필드 위젯
///
/// 포커스시 검은색 테두리, 검은색 커서, 일반 텍스트 선택 배경색 사용
class TextInputField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final double? fontSize;
  final double? hintFontSize;
  final EdgeInsetsGeometry? contentPadding;

  const TextInputField({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.fontSize = 14,
    this.hintFontSize,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black,
            selectionColor: Colors.grey.withValues(alpha: 0.3),
            selectionHandleColor: Colors.black,
          ),
        ),
        child: TextField(
          controller: controller ?? (initialValue != null ? TextEditingController(text: initialValue) : null),
          onChanged: enabled && !readOnly ? onChanged : null,
          onTap: onTap,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: keyboardType,
          cursorColor: Colors.black,
          style: TextStyle(fontSize: fontSize),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: hintFontSize ?? fontSize,
              color: AppTheme.placeholder,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: enabled && !readOnly ? Colors.grey[50] : Colors.grey[100],
          ),
        ),
      ),
    );
  }
}
