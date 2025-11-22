import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class CompletionStep extends StatelessWidget {
  const CompletionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.green, size: 40),
        ),
        const SizedBox(height: 24),
        const Text(
          '회원가입 완료!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '핏클에 오신 것을 환영합니다',
          style: TextStyle(color: AppTheme.mutedForeground),
        ),
        const SizedBox(height: 24),
        const CircularProgressIndicator(),
      ],
    );
  }
}
