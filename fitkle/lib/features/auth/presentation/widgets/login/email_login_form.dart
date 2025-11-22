import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/core/utils/validators.dart';

class EmailLoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool showPassword;
  final VoidCallback onTogglePassword;

  const EmailLoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.showPassword,
    required this.onTogglePassword,
  });

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  bool _showKoreanWarning = false;

  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_checkKoreanInput);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_checkKoreanInput);
    super.dispose();
  }

  void _checkKoreanInput() {
    final text = widget.passwordController.text;
    final hasKorean = RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]').hasMatch(text);

    if (hasKorean != _showKoreanWarning) {
      setState(() {
        _showKoreanWarning = hasKorean;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Email Field
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppTheme.border),
                ),
              ),
              child: TextFormField(
                controller: widget.emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: AppTheme.inputCursor,
                decoration: InputDecoration(
                  hintText: '이메일',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: (value) {
                  return Validators.validateEmail(value);
                },
              ),
            ),
            // Password Field
            TextFormField(
              controller: widget.passwordController,
              obscureText: !widget.showPassword,
              cursorColor: AppTheme.inputCursor,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: '비밀번호',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    widget.showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: AppTheme.mutedForeground,
                  ),
                  onPressed: widget.onTogglePassword,
                ),
              ),
              validator: (value) {
                final result = Validators.validatePassword(value);
                if (!result.isValid && result.errors.isNotEmpty) {
                  return result.errors.join('\n');
                }
                return null;
              },
            ),

            // Korean Warning
            if (_showKoreanWarning)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF4E5),
                  border: Border(
                    top: BorderSide(color: Color(0xFFFFE0B2)),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Color(0xFFE65100),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '한글이 포함되어 있습니다. 키보드를 확인해주세요.',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFFE65100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
