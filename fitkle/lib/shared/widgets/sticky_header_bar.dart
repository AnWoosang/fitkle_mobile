import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/buttons/detail_action_button.dart';

/// 상단 고정 헤더바 위젯
/// 뉴스 상세, 프로필 등에서 사용되는 공통 AppBar
class StickyHeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const StickyHeaderBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.background,
              AppTheme.background,
              AppTheme.background.withValues(alpha: 0.0),
            ],
          ),
          border: const Border(
            bottom: BorderSide(color: AppTheme.border, width: 0.5),
          ),
        ),
      ),
      leading: DetailBackButton(
        onPressed: onBackPressed,
        showBackground: false,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.foreground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
    );
  }
}
