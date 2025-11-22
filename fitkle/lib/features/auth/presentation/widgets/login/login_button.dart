import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final bool isFormValid;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.isLoading,
    required this.isFormValid,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: (isLoading || !isFormValid) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
              ? AppTheme.primary
              : AppTheme.mutedForeground.withValues(alpha: 0.15),
          foregroundColor: isFormValid ? Colors.white : AppTheme.mutedForeground,
          disabledBackgroundColor: AppTheme.mutedForeground.withValues(alpha: 0.15),
          disabledForegroundColor: AppTheme.mutedForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isFormValid ? Colors.white : AppTheme.mutedForeground,
                  ),
                ),
              )
            : const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
