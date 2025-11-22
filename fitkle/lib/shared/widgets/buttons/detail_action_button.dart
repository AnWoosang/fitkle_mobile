import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// Detail screen action button
/// Used in detail screens (event, news, profile, etc.)
class DetailActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final bool isActive;
  final Color? activeColor;
  final bool showBackground;

  const DetailActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.isActive = false,
    this.activeColor,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: 40,
      height: 40,
      decoration: showBackground
          ? BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : null,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: isActive
            ? (activeColor ?? AppTheme.primary)
            : (color ?? AppTheme.foreground),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        iconSize: 24,
      ),
    );
  }
}

/// Back button specifically for detail screens
class DetailBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool showBackground;

  const DetailBackButton({
    super.key,
    this.onPressed,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: 40,
      height: 40,
      decoration: showBackground
          ? BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : null,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
        color: AppTheme.foreground,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        iconSize: 24,
      ),
    );
  }
}
