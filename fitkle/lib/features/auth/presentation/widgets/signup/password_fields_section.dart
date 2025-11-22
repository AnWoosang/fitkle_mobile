import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/signup_text_field.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/password_match_indicator.dart';

class PasswordFieldsSection extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final bool showPassword;
  final bool showPasswordConfirm;
  final VoidCallback onTogglePassword;
  final VoidCallback onTogglePasswordConfirm;

  const PasswordFieldsSection({
    super.key,
    required this.passwordController,
    required this.passwordConfirmController,
    required this.showPassword,
    required this.showPasswordConfirm,
    required this.onTogglePassword,
    required this.onTogglePasswordConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Password field
        SignupTextField(
          controller: passwordController,
          label: '비밀번호',
          hint: '8+ chars with letters, numbers & symbols',
          obscureText: !showPassword,
          suffixIcon: IconButton(
            icon: Icon(
              showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
              color: AppTheme.mutedForeground,
            ),
            onPressed: onTogglePassword,
          ),
        ),
        const SizedBox(height: 20),

        // Password confirm field
        SignupTextField(
          controller: passwordConfirmController,
          label: '비밀번호 확인',
          hint: 'Please enter your password again',
          obscureText: !showPasswordConfirm,
          suffixIcon: IconButton(
            icon: Icon(
              showPasswordConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
              color: AppTheme.mutedForeground,
            ),
            onPressed: onTogglePasswordConfirm,
          ),
        ),
        PasswordMatchIndicator(
          password: passwordController.text,
          confirmPassword: passwordConfirmController.text,
        ),
      ],
    );
  }
}
