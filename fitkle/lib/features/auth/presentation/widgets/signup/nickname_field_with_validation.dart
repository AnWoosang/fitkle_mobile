import 'package:flutter/material.dart';
import 'package:fitkle/core/utils/validators.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/signup_text_field.dart';
import 'package:fitkle/shared/widgets/validation_message.dart';

class NicknameFieldWithValidation extends StatelessWidget {
  final TextEditingController controller;
  final bool isCheckingNickname;
  final bool? isNicknameAvailable;

  const NicknameFieldWithValidation({
    super.key,
    required this.controller,
    required this.isCheckingNickname,
    required this.isNicknameAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SignupTextField(
          controller: controller,
          label: '닉네임',
          hint: 'Enter your nickname',
          maxLength: 20,
          validator: Validators.validateNickname,
        ),

        // Validation error or availability status
        if (controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Builder(
              builder: (context) {
                final validationError = Validators.validateNickname(controller.text);

                // 검증 에러가 있으면 에러 메시지 표시
                if (validationError != null) {
                  return ValidationMessage.error(message: validationError);
                }

                // 검증을 통과하면 중복 확인 상태 표시
                if (isCheckingNickname) {
                  return const ValidationMessage.loading(
                    message: '중복 확인 중...',
                  );
                } else if (isNicknameAvailable == true) {
                  return const ValidationMessage.success(
                    message: '사용 가능한 닉네임입니다',
                  );
                } else if (isNicknameAvailable == false) {
                  return const ValidationMessage.error(
                    message: '이미 사용 중인 닉네임입니다',
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
      ],
    );
  }
}
