import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/core/utils/validators.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/signup_text_field.dart';
import 'package:fitkle/shared/widgets/validation_message.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/password_fields_section.dart';
import 'package:fitkle/features/auth/domain/models/signup_data.dart';

class BasicInfoStep extends StatefulWidget {
  final SignupData initialData;
  final Function(SignupData) onSubmit;

  const BasicInfoStep({
    super.key,
    required this.initialData,
    required this.onSubmit,
  });

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmController;

  bool _showPassword = false;
  bool _showPasswordConfirm = false;
  bool _agreedToTerms = false;
  bool _isFormValid = false;

  // Email validation
  bool _isCheckingEmail = false;
  bool? _isEmailAvailable;
  Timer? _emailDebounce;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData.name);
    _emailController = TextEditingController(text: widget.initialData.email);
    _passwordController = TextEditingController(text: widget.initialData.password);
    _passwordConfirmController = TextEditingController(text: widget.initialData.passwordConfirm);
    _agreedToTerms = widget.initialData.agreedToTerms;

    _passwordController.addListener(_validateForm);
    _passwordConfirmController.addListener(_validateForm);
    _nameController.addListener(_validateForm);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailDebounce?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _emailDebounce?.cancel();

    setState(() {
      _isEmailAvailable = null;
      _isCheckingEmail = false;
    });

    final email = _emailController.text;
    final basicError = Validators.validateEmail(email);

    if (basicError == null && email.isNotEmpty) {
      setState(() => _isCheckingEmail = true);

      _emailDebounce = Timer(const Duration(milliseconds: 800), () async {
        final isAvailable = await Validators.checkEmailAvailability(email);

        if (mounted && _emailController.text == email) {
          setState(() {
            _isCheckingEmail = false;
            _isEmailAvailable = isAvailable;
          });
        }
      });
    }

    _validateForm();
  }

  void _validateForm() {
    final nicknameError = Validators.validateNickname(_nameController.text);
    final emailError = Validators.validateEmail(_emailController.text);
    final passwordValidation = Validators.validatePassword(_passwordController.text);
    final passwordsMatch = _passwordController.text == _passwordConfirmController.text;

    setState(() {
      _isFormValid = nicknameError == null &&
                      emailError == null &&
                      passwordValidation.isValid &&
                      passwordsMatch &&
                      _nameController.text.isNotEmpty;
    });
  }

  void _handleSubmit() {
    if (!_agreedToTerms) {
      _showSnackBar('이용약관 및 개인정보처리방침에 동의해주세요.');
      return;
    }
    if (_passwordController.text != _passwordConfirmController.text) {
      _showSnackBar('비밀번호가 일치하지 않습니다.');
      return;
    }

    final data = widget.initialData.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      passwordConfirm: _passwordConfirmController.text,
      agreedToTerms: _agreedToTerms,
    );

    widget.onSubmit(data);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            '기본 정보 입력',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '회원가입을 위한 정보를 입력해주세요',
            style: TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
          ),
          const SizedBox(height: 32),

          // Nickname field
          SignupTextField(
            controller: _nameController,
            label: '닉네임',
            hint: 'Enter your nickname',
            maxLength: 20,
            validator: Validators.validateNickname,
          ),
          const SizedBox(height: 20),

          // Email field with duplication check
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignupTextField(
                controller: _emailController,
                label: '이메일',
                hint: 'Enter your email',
                validator: Validators.validateEmail,
              ),
              // Email availability status
              if (_emailController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Builder(
                    builder: (context) {
                      final validationError = Validators.validateEmail(_emailController.text);

                      if (validationError != null) {
                        return const SizedBox.shrink();
                      }

                      if (_isCheckingEmail) {
                        return const ValidationMessage.loading(
                          message: '중복 확인 중...',
                        );
                      } else if (_isEmailAvailable == true) {
                        return const ValidationMessage.success(
                          message: '사용 가능한 이메일입니다',
                        );
                      } else if (_isEmailAvailable == false) {
                        return const ValidationMessage.error(
                          message: '이미 사용 중인 이메일입니다',
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Password fields
          PasswordFieldsSection(
            passwordController: _passwordController,
            passwordConfirmController: _passwordConfirmController,
            showPassword: _showPassword,
            showPasswordConfirm: _showPasswordConfirm,
            onTogglePassword: () => setState(() => _showPassword = !_showPassword),
            onTogglePasswordConfirm: () => setState(() => _showPasswordConfirm = !_showPasswordConfirm),
          ),
          const SizedBox(height: 24),

          // Terms agreement
          GestureDetector(
            onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _agreedToTerms ? Icons.check_box : Icons.check_box_outline_blank,
                    color: _agreedToTerms ? AppTheme.primary : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
                        children: const [
                          TextSpan(
                            text: '이용약관',
                            style: TextStyle(
                              color: AppTheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' 및 '),
                          TextSpan(
                            text: '개인정보처리방침',
                            style: TextStyle(
                              color: AppTheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: '에 동의합니다'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: (_isFormValid && _agreedToTerms) ? _handleSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                disabledBackgroundColor: AppTheme.mutedForeground.withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '다음 단계로',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
