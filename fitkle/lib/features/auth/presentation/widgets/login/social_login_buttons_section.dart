import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class SocialLoginButtonsSection extends StatelessWidget {
  final Function(String) onSocialLogin;

  const SocialLoginButtonsSection({
    super.key,
    required this.onSocialLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        _buildCircularButton(
          onTap: () => onSocialLogin('Google'),
          backgroundColor: Colors.white,
          borderColor: AppTheme.border,
          child: Image.asset(
            'assets/images/google_logo.png',
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.g_mobiledata, size: 20),
              );
            },
          ),
        ),
        const SizedBox(width: 16),

        // Kakao
        _buildCircularButton(
          onTap: () => onSocialLogin('Kakao'),
          backgroundColor: const Color(0xFFFEE500),
          child: const Icon(
            Icons.chat_bubble,
            color: Colors.black,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),

        // Apple
        _buildCircularButton(
          onTap: () => onSocialLogin('Apple'),
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.apple,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularButton({
    required VoidCallback onTap,
    required Color backgroundColor,
    Color? borderColor,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: borderColor != null
              ? Border.all(color: borderColor, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
