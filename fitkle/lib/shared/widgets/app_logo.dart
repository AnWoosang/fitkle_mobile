import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final String? subtitle;
  final bool compact;
  final double? height;

  const AppLogo({
    super.key,
    this.subtitle,
    this.compact = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final logoHeight = height ?? (compact ? 28 : 32);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: logoHeight,
          fit: BoxFit.contain,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }
}
