import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/auth/presentation/screens/signup_screen.dart';

class SignupProgressBar extends StatelessWidget {
  final SignupStep currentStep;

  const SignupProgressBar({
    super.key,
    required this.currentStep,
  });

  int _getStepIndex(SignupStep step) {
    const order = [
      SignupStep.method,
      SignupStep.info,
      SignupStep.emailVerify,
      SignupStep.additionalInfo,
      SignupStep.complete,
    ];
    return order.indexOf(step);
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'key': SignupStep.info, 'label': '기본정보 입력', 'number': 1},
      {'key': SignupStep.emailVerify, 'label': '본인인증', 'number': 2},
      {'key': SignupStep.additionalInfo, 'label': '추가정보', 'number': 3},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final stepIndex = index ~/ 2;
            final isComplete = _getStepIndex(currentStep) > stepIndex;
            return Container(
              width: 60,
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: isComplete ? AppTheme.primary : AppTheme.border,
            );
          }

          // Step circle
          final stepIndex = index ~/ 2;
          final step = steps[stepIndex];
          final isActive = currentStep == step['key'];
          final isComplete = _getStepIndex(currentStep) > stepIndex;

          return Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isComplete || isActive ? AppTheme.primary : AppTheme.secondary,
                ),
                child: Center(
                  child: isComplete
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : Text(
                          '${step['number']}',
                          style: TextStyle(
                            color: isActive ? Colors.white : AppTheme.mutedForeground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                step['label'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive || isComplete ? AppTheme.primary : AppTheme.mutedForeground,
                  fontWeight: isActive || isComplete ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
