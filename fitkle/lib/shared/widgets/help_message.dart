import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// 도움말 메시지 위젯
class HelpMessage extends StatelessWidget {
  final String message;

  const HelpMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 16,
          color: AppTheme.mutedForeground,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.mutedForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
