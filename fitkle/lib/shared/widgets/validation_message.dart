import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// 검증 메시지의 상태
enum ValidationMessageType {
  success,
  error,
  loading,
}

/// 공통 검증 메시지 위젯
class ValidationMessage extends StatelessWidget {
  final ValidationMessageType type;
  final String message;

  const ValidationMessage({
    super.key,
    required this.type,
    required this.message,
  });

  /// 성공 메시지 생성자
  const ValidationMessage.success({
    super.key,
    required this.message,
  }) : type = ValidationMessageType.success;

  /// 에러 메시지 생성자
  const ValidationMessage.error({
    super.key,
    required this.message,
  }) : type = ValidationMessageType.error;

  /// 로딩 메시지 생성자
  const ValidationMessage.loading({
    super.key,
    required this.message,
  }) : type = ValidationMessageType.loading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIcon(),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 12,
              color: _getColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    switch (type) {
      case ValidationMessageType.success:
        return Icon(
          Icons.check_circle,
          size: 16,
          color: _getColor(),
        );
      case ValidationMessageType.error:
        return Icon(
          Icons.error_outline,
          size: 16,
          color: _getColor(),
        );
      case ValidationMessageType.loading:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
    }
  }

  Color _getColor() {
    switch (type) {
      case ValidationMessageType.success:
        return Colors.green;
      case ValidationMessageType.error:
        return Colors.red;
      case ValidationMessageType.loading:
        return AppTheme.mutedForeground;
    }
  }
}
