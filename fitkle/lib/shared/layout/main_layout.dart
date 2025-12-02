import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/speed_dial_fab.dart';
import 'package:fitkle/shared/widgets/user_avatar.dart';
import 'package:fitkle/features/auth/presentation/providers/auth_provider.dart';
import 'package:fitkle/features/member/presentation/providers/member_provider.dart';
import 'package:fitkle/shared/providers/toast_provider.dart';

class MainLayout extends ConsumerStatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  void _onItemTapped(int index) {
    // 프로필 탭인 경우 로그인 상태 확인
    if (index == 4) {
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      if (isAuthenticated) {
        context.go('/profile');
      } else {
        context.go('/login');
      }
      return;
    }

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/events'); // 탐색 - 이벤트 탐색 화면
        break;
      case 2:
        context.go('/groups');
        break;
      case 3:
        context.go('/messages');
        break;
    }
  }

  void _handleCreateGroup() {
    context.push('/groups/create');
  }

  void _handleCreateEvent() {
    context.push('/events/create');
  }

  bool _shouldShowFab() {
    // Show FAB only on Home (0), Events (1), and Groups (2) tabs
    return widget.currentIndex == 0 ||
           widget.currentIndex == 1 ||
           widget.currentIndex == 2;
  }

  @override
  Widget build(BuildContext context) {
    // Listen to toast messages
    ref.listen<ToastMessage?>(toastProvider, (previous, next) {
      if (next != null) {
        // Get color based on toast type
        Color backgroundColor;
        switch (next.type) {
          case ToastType.error:
            backgroundColor = AppTheme.destructive;
            break;
          case ToastType.success:
            backgroundColor = Colors.green;
            break;
          case ToastType.warning:
            backgroundColor = Colors.orange;
            break;
          case ToastType.info:
            backgroundColor = AppTheme.foreground;
            break;
        }

        // Use Overlay to show toast above everything including modals
        final overlay = Overlay.of(context);
        OverlayEntry? overlayEntry;

        overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  next.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );

        overlay.insert(overlayEntry);

        // Remove overlay after duration
        Future.delayed(const Duration(seconds: 2), () {
          overlayEntry?.remove();
          ref.read(toastProvider.notifier).clear();
        });
      }
    });

    return Scaffold(
      body: widget.child,
      floatingActionButton: _shouldShowFab()
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SpeedDialFab(
                onCreateGroup: _handleCreateGroup,
                onCreateEvent: _handleCreateEvent,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          border: Border(
            top: BorderSide(
              color: AppTheme.border.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SizedBox(
              height: 62,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.search,
                  activeIcon: Icons.search,
                  label: 'Explore',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.groups_outlined,
                  activeIcon: Icons.groups,
                  label: 'Groups',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'Messages',
                  index: 3,
                ),
                _buildProfileNavItem(),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = widget.currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 24,
                color: isActive ? AppTheme.primary : AppTheme.mutedForeground,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppTheme.primary : AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileNavItem() {
    final isActive = widget.currentIndex == 4;
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final currentMemberAsync = ref.watch(currentMemberProvider);

    // 로그인된 경우 아바타 표시, 아니면 아이콘 표시
    Widget iconWidget;
    if (isAuthenticated) {
      iconWidget = currentMemberAsync.when(
        data: (member) => SizedBox(
          width: 24,
          height: 24,
          child: UserAvatar(
            avatarUrl: member?.avatarUrl,
            size: 24,
            backgroundColor: isActive ? AppTheme.primary.withValues(alpha: 0.1) : Colors.grey[200],
            iconColor: isActive ? AppTheme.primary : AppTheme.mutedForeground,
          ),
        ),
        loading: () => Icon(
          Icons.person_outline,
          size: 24,
          color: isActive ? AppTheme.primary : AppTheme.mutedForeground,
        ),
        error: (_, __) => Icon(
          Icons.person_outline,
          size: 24,
          color: isActive ? AppTheme.primary : AppTheme.mutedForeground,
        ),
      );
    } else {
      iconWidget = Icon(
        isActive ? Icons.login : Icons.login_outlined,
        size: 24,
        color: isActive ? AppTheme.primary : AppTheme.mutedForeground,
      );
    }

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(4),
        child: SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(height: 4),
              Text(
                isAuthenticated ? 'My' : 'Login',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppTheme.primary : AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
