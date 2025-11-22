import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/validation_message.dart';
import 'package:fitkle/shared/widgets/help_message.dart';
import 'package:fitkle/features/auth/domain/models/signup_data.dart';

class VerificationStep extends StatefulWidget {
  final SignupData initialData;
  final Function(SignupData) onSubmit;

  const VerificationStep({
    super.key,
    required this.initialData,
    required this.onSubmit,
  });

  @override
  State<VerificationStep> createState() => _VerificationStepState();
}

class _VerificationStepState extends State<VerificationStep> {
  late TextEditingController _phoneController;
  late TextEditingController _emailCodeController;
  late TextEditingController _phoneCodeController;

  late String _email;
  bool _isEmailSent = false;
  bool _isEmailVerified = false;
  bool _isPhoneSent = false;
  bool _isPhoneVerified = false;

  @override
  void initState() {
    super.initState();
    _email = widget.initialData.email;
    _phoneController = TextEditingController(text: widget.initialData.phoneNumber);
    _emailCodeController = TextEditingController(text: widget.initialData.emailCode);
    _phoneCodeController = TextEditingController(text: widget.initialData.phoneCode);
    _isEmailVerified = widget.initialData.isEmailVerified;
    _isPhoneVerified = widget.initialData.isPhoneVerified;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailCodeController.dispose();
    _phoneCodeController.dispose();
    super.dispose();
  }

  void _handleSendEmailCode() {
    final isResend = _isEmailSent;
    setState(() => _isEmailSent = true);
    _showSnackBar(
      isResend
          ? '$_email로 인증 코드를 재전송했습니다.'
          : '$_email로 인증 코드를 발송했습니다.',
    );
  }

  void _handleVerifyEmail() {
    if (_emailCodeController.text.length == 6) {
      setState(() => _isEmailVerified = true);
      _showSnackBar('이메일이 인증되었습니다!');
    } else {
      _showSnackBar('6자리 인증 코드를 입력해주세요.');
    }
  }

  void _handleSendPhoneCode() {
    if (_phoneController.text.length < 10) {
      _showSnackBar('올바른 휴대폰 번호를 입력해주세요.');
      return;
    }
    setState(() => _isPhoneSent = true);
    _showSnackBar('${_phoneController.text}로 인증 코드를 발송했습니다.');
  }

  void _handleVerifyPhone() {
    if (_phoneCodeController.text.length != 6) {
      _showSnackBar('6자리 인증 코드를 입력해주세요.');
      return;
    }
    setState(() => _isPhoneVerified = true);
    _showSnackBar('휴대폰이 인증되었습니다!');
  }

  void _handleSubmit() {
    final data = widget.initialData.copyWith(
      phoneNumber: _phoneController.text,
      emailCode: _emailCodeController.text,
      phoneCode: _phoneCodeController.text,
      isEmailVerified: _isEmailVerified,
      isPhoneVerified: _isPhoneVerified,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '본인인증',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '이메일과 휴대폰 번호를 인증해주세요',
            style: TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
          ),
          const SizedBox(height: 32),

          // Email verification section
          const Text(
            '이메일 인증',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Email display with send/resend button
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.mutedForeground.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _email,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                if (!_isEmailVerified) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _handleSendEmailCode,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      overlayColor: Colors.transparent,
                    ),
                    child: Text(
                      _isEmailSent ? '재전송' : '전송',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Help message below email
          if (!_isEmailVerified) ...[
            const SizedBox(height: 8),
            HelpMessage(
              message: _isEmailSent
                  ? '이메일로 인증메일이 전송되었습니다'
                  : '전송 버튼을 눌러 이메일 인증을 완료해주세요',
            ),
          ],
          const SizedBox(height: 16),

          // Email verification code input
          if (_isEmailSent && !_isEmailVerified) ...[
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailCodeController,
                      cursorColor: AppTheme.inputCursor,
                      decoration: InputDecoration(
                        hintText: '6자리 인증 코드',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _handleVerifyEmail,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      overlayColor: Colors.transparent,
                    ),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Success message after verification
          if (_isEmailVerified) ...[
            const SizedBox(height: 8),
            const ValidationMessage.success(
              message: '이메일 인증이 완료되었습니다',
            ),
          ],

          const SizedBox(height: 32),

          // Phone verification section
          const Text(
            '휴대폰 인증',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Phone number input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  cursorColor: AppTheme.inputCursor,
                  decoration: InputDecoration(
                    hintText: '휴대폰 번호 (-없이)',
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
                  keyboardType: TextInputType.phone,
                  enabled: !_isPhoneVerified,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isPhoneVerified || _phoneController.text.isEmpty)
                      ? null
                      : _handleSendPhoneCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPhoneVerified ? AppTheme.secondary : null,
                    disabledBackgroundColor: _isPhoneVerified ? AppTheme.secondary : null,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(_isPhoneVerified ? '인증됨' : (_isPhoneSent ? '재전송' : '인증')),
                ),
              ),
            ],
          ),

          // Phone verification code input
          if (_isPhoneSent && !_isPhoneVerified) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneCodeController,
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
                      counterText: '',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleVerifyPhone,
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ],

          if (_isPhoneVerified) ...[
            const SizedBox(height: 8),
            const ValidationMessage.success(
              message: '휴대폰 인증이 완료되었습니다',
            ),
          ],

          const SizedBox(height: 32),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                (_isEmailVerified && _isPhoneVerified)
                    ? '다음 단계로'
                    : '나중에 인증하기',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
