import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final Widget child;

  const SocialLoginButton({
    super.key,
    required this.onTap,
    required this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: backgroundColor == Colors.white
                ? AppTheme.border
                : Colors.transparent,
          ),
        ),
        child: child,
      ),
    );
  }
}
