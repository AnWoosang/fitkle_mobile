import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/buttons/detail_action_button.dart';

/// Configuration for detail screen app bar actions
class DetailAppBarAction {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? activeColor;
  final bool isActive;

  const DetailAppBarAction({
    required this.icon,
    required this.onPressed,
    this.activeColor,
    this.isActive = false,
  });
}

/// Reusable SliverAppBar for detail screens
class DetailScreenAppBar extends StatelessWidget {
  final double expandedHeight;
  final Widget headerContent;
  final bool isCollapsed;
  final VoidCallback onBackPressed;
  final List<DetailAppBarAction> actions;

  const DetailScreenAppBar({
    super.key,
    required this.headerContent,
    required this.isCollapsed,
    required this.onBackPressed,
    this.expandedHeight = 272,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      backgroundColor: AppTheme.background,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceElevated: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppTheme.border,
        ),
      ),
      leading: DetailBackButton(
        onPressed: onBackPressed,
      ),
      actions: [
        ...actions.map((action) => DetailActionButton(
          icon: action.icon,
          onPressed: action.onPressed,
          color: AppTheme.foreground,
          isActive: action.isActive,
          activeColor: action.activeColor,
        )),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: headerContent,
      ),
    );
  }
}
