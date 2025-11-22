import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/core/utils/validators.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/signup_text_field.dart';
import 'package:fitkle/shared/widgets/validation_message.dart';

class EmailFieldWithValidation extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController codeController;
  final bool isCheckingEmail;
  final bool? isEmailAvailable;
  final bool isEmailSent;
  final bool isEmailVerified;
  final VoidCallback onSendCode;
  final VoidCallback onVerifyCode;

  const EmailFieldWithValidation({
    super.key,
    required this.emailController,
    required this.codeController,
    required this.isCheckingEmail,
    required this.isEmailAvailable,
    required this.isEmailSent,
    required this.isEmailVerified,
    required this.onSendCode,
    required this.onVerifyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '이메일',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SignupTextField(
                controller: emailController,
                hint: 'Enter your email',
                enabled: !isEmailVerified,
                showLabel: false,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: (isEmailVerified || isEmailAvailable != true) ? null : onSendCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEmailVerified ? AppTheme.secondary : null,
                  disabledBackgroundColor: isEmailVerified ? AppTheme.secondary : null,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(isEmailVerified ? '인증됨' : (isEmailSent ? '재전송' : '인증')),
              ),
            ),
          ],
        ),

        // Email availability status
        if (emailController.text.isNotEmpty &&
            Validators.validateEmail(emailController.text) == null &&
            !isEmailVerified)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Builder(
              builder: (context) {
                if (isCheckingEmail) {
                  return const ValidationMessage.loading(
                    message: '중복 확인 중...',
                  );
                } else if (isEmailAvailable == true) {
                  return const ValidationMessage.success(
                    message: '사용 가능한 이메일입니다',
                  );
                } else if (isEmailAvailable == false) {
                  return const ValidationMessage.error(
                    message: '이미 사용 중인 이메일입니다',
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

        // Email verification code input
        if (isEmailSent && !isEmailVerified) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: codeController,
                  cursorColor: AppTheme.inputCursor,
                  decoration: InputDecoration(
                    hintText: '6자리 인증 코드',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.border, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.border, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.inputFocusBorder, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: onVerifyCode,
                  child: const Text('확인'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
