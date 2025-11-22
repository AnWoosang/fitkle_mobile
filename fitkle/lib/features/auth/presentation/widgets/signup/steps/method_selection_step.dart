import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/app_logo.dart';
import 'package:fitkle/features/auth/presentation/widgets/login/social_login_button.dart';
import 'package:fitkle/features/auth/presentation/screens/signup_screen.dart';

class MethodSelectionStep extends StatelessWidget {
  final Function(SignupMethod) onMethodSelected;

  const MethodSelectionStep({
    super.key,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo and title
        const AppLogo(height: 54),
        const SizedBox(height: 24),
        Text(
          'Join the Fitkle community',
          style: TextStyle(fontSize: 13, color: AppTheme.mutedForeground),
        ),
        const SizedBox(height: 40),

        // Social signup buttons
        SocialLoginButton(
          onTap: () => onMethodSelected(SignupMethod.google),
          backgroundColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/google_logo.png',
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.g_mobiledata, size: 16),
                  );
                },
              ),
              const SizedBox(width: 12),
              const Text(
                'Google로 가입하기',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        SocialLoginButton(
          onTap: () => onMethodSelected(SignupMethod.kakao),
          backgroundColor: const Color(0xFFFEE500),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'K',
                    style: TextStyle(
                      color: Color(0xFFFEE500),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '카카오로 가입하기',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        SocialLoginButton(
          onTap: () => onMethodSelected(SignupMethod.apple),
          backgroundColor: Colors.black,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.apple, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                'Apple로 가입하기',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: AppTheme.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '또는',
                style: TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
              ),
            ),
            Expanded(child: Divider(color: AppTheme.border)),
          ],
        ),
        const SizedBox(height: 24),

        // Email signup button
        SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: () => onMethodSelected(SignupMethod.email),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.border, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail_outline, size: 20),
                SizedBox(width: 8),
                Text('이메일로 가입하기', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Login link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '이미 계정이 있으신가요? ',
              style: TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
            ),
            TextButton(
              onPressed: () => context.go('/login'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                '로그인',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
