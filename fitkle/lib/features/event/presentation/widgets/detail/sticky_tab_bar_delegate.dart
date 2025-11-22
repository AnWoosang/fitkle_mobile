import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: AppTheme.background,
      elevation: shrinkOffset > 0 ? 4 : 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.border,
              width: 1,
            ),
          ),
        ),
        child: tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(StickyTabBarDelegate oldDelegate) {
    return false;
  }
}

