import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/signup_text_field.dart';

class EmailVerificationSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController emailCodeController;
  final bool isEmailSent;
  final bool isEmailVerified;
  final VoidCallback onSendCode;
  final VoidCallback onVerifyCode;

  const EmailVerificationSection({
    super.key,
    required this.emailController,
    required this.emailCodeController,
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
                hint: 'your@email.com',
                icon: Icons.mail_outline,
                enabled: !isEmailVerified,
                showLabel: false,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: isEmailVerified ? null : onSendCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEmailVerified ? AppTheme.secondary : null,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(isEmailVerified ? '인증됨' : (isEmailSent ? '재전송' : '인증')),
              ),
            ),
          ],
        ),
        if (isEmailSent && !isEmailVerified) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: emailCodeController,
                  decoration: InputDecoration(
                    hintText: '6자리 인증 코드',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.border, width: 2),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text('확인'),
                ),
              ),
            ],
          ),
        ],
        if (isEmailVerified)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text('이메일 인증 완료', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
      ],
    );
  }
}
