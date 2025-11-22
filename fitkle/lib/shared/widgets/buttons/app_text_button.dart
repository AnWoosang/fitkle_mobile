import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// Common text button widget used throughout the app
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? fontSize;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          color: color ?? AppTheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
