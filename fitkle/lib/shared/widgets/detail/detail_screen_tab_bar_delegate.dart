import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// Configurable sticky tab bar delegate for detail screens
class DetailScreenTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final void Function(int) onTap;
  final List<String> tabLabels;
  final double height;

  DetailScreenTabBarDelegate({
    required this.tabController,
    required this.onTap,
    required this.tabLabels,
    this.height = 48,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: AppTheme.background,
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.border,
              width: 1,
            ),
          ),
        ),
        child: TabBar(
          controller: tabController,
          onTap: onTap,
          indicator: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppTheme.foreground,
                width: 2,
              ),
            ),
          ),
          labelColor: AppTheme.foreground,
          unselectedLabelColor: AppTheme.mutedForeground,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          dividerColor: AppTheme.border,
          tabs: tabLabels.map((label) => Tab(text: label)).toList(),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant DetailScreenTabBarDelegate oldDelegate) {
    return tabLabels != oldDelegate.tabLabels;
  }
}
