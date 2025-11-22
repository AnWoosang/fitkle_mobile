import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// Common icon button widget used throughout the app
/// Provides consistent styling and behavior for all icon buttons
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size,
    this.padding,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: size),
      onPressed: onPressed,
      color: color ?? AppTheme.foreground,
      padding: padding ?? const EdgeInsets.all(8.0),
      tooltip: tooltip,
    );
  }
}
