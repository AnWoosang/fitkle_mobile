import 'package:flutter/material.dart';

/// 사용자 아바타 위젯
///
/// avatarUrl이 있으면 이미지를 표시하고, 없으면 사람 아이콘을 표시합니다.
class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.grey[200];
    final iColor = iconColor ?? Colors.grey[400];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatarUrl != null ? Colors.transparent : bgColor,
        shape: BoxShape.circle,
      ),
      child: avatarUrl != null
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로드 실패 시 기본 아이콘 표시
                  return Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: iColor,
                  );
                },
              ),
            )
          : Icon(
              Icons.person,
              size: size * 0.5,
              color: iColor,
            ),
    );
  }
}
