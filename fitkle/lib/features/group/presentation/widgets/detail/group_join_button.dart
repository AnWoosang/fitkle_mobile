import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class GroupJoinButton extends StatelessWidget {
  final bool isJoined;
  final bool isAppBarCollapsed;
  final VoidCallback onPressed;

  const GroupJoinButton({
    super.key,
    required this.isJoined,
    required this.isAppBarCollapsed,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isJoined ? Colors.transparent : AppTheme.primary,
          foregroundColor: isJoined ? AppTheme.foreground : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: isJoined ? 0 : 2,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          side: isJoined
              ? const BorderSide(color: AppTheme.border, width: 1)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 20,
              color: isJoined ? AppTheme.foreground : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              isJoined ? '그룹 나가기' : '그룹 가입하기',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
