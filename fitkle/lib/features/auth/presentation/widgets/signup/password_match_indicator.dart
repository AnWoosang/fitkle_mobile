import 'package:flutter/material.dart';
import 'package:fitkle/shared/widgets/validation_message.dart';

class PasswordMatchIndicator extends StatelessWidget {
  final String password;
  final String confirmPassword;

  const PasswordMatchIndicator({
    super.key,
    required this.password,
    required this.confirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty || confirmPassword.isEmpty) {
      return const SizedBox.shrink();
    }

    final isMatch = password == confirmPassword;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: isMatch
          ? const ValidationMessage.success(
              message: '비밀번호가 일치합니다',
            )
          : const ValidationMessage.error(
              message: '비밀번호가 일치하지 않습니다',
            ),
    );
  }
}
