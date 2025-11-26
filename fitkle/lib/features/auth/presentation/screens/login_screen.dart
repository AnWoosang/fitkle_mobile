import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/core/utils/validators.dart';
import 'package:fitkle/shared/widgets/app_text_button.dart';
import 'package:fitkle/shared/widgets/app_logo.dart';
import 'package:fitkle/features/auth/presentation/providers/auth_provider.dart';
import 'package:fitkle/features/auth/presentation/widgets/login/social_login_buttons_section.dart';
import 'package:fitkle/features/auth/presentation/widgets/login/email_login_form.dart';
import 'package:fitkle/features/auth/presentation/widgets/login/login_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    // 로그인은 단순히 이메일과 비밀번호가 입력되었는지만 확인
    final isEmailEntered = _emailController.text.trim().isNotEmpty;
    final isPasswordEntered = _passwordController.text.isNotEmpty;

    setState(() {
      _isFormValid = isEmailEntered && isPasswordEntered;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    debugPrint('========== LOGIN SCREEN ==========');
    debugPrint('[LoginScreen] 로그인 시도');
    debugPrint('[LoginScreen] email: $email');
    debugPrint('[LoginScreen] password: ${'*' * password.length} (${password.length}자)');

    final success = await ref.read(authProvider.notifier).signInWithEmail(
      email,
      password,
    );

    debugPrint('[LoginScreen] 로그인 결과: $success');

    if (mounted) {
      if (success) {
        context.go('/home');
      } else {
        // 로그인 실패 시 사용자 친화적인 에러 메시지 표시
        _showErrorSnackBar('아이디와 비밀번호를 확인해주세요');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    // TODO: Implement social login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider 로그인 준비 중입니다')),
    );
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showErrorSnackBar('비밀번호를 재설정할 이메일을 입력해주세요');
      return;
    }

    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _showErrorSnackBar(emailError);
      return;
    }

    final success = await ref.read(authProvider.notifier).resetPassword(email);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('비밀번호 재설정 이메일을 발송했습니다'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errorMessage = ref.read(authProvider).errorMessage;
        if (errorMessage != null) {
          _showErrorSnackBar(errorMessage);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppTextButton(
                    label: 'SKIP',
                    onPressed: () => context.go('/home'),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // Logo & Welcome Section
                      Center(
                        child: Column(
                          children: [
                            // Logo
                            const AppLogo(height: 54),
                            const SizedBox(height: 24),

                            // Welcome text
                            const Text(
                              'Welcome!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Meet new friends at Fitkle',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Social Login Buttons
                      SocialLoginButtonsSection(
                        onSocialLogin: _handleSocialLogin,
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
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.mutedForeground,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: AppTheme.border)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Email Login Form
                      EmailLoginForm(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        showPassword: _showPassword,
                        onTogglePassword: () => setState(() => _showPassword = !_showPassword),
                      ),

                      const SizedBox(height: 16),

                      // Login Button
                      LoginButton(
                        isLoading: isLoading,
                        isFormValid: _isFormValid,
                        onPressed: _handleLogin,
                      ),

                      const SizedBox(height: 24),

                      // Forgot Password
                      Center(
                        child: TextButton(
                          onPressed: isLoading ? null : _handleForgotPassword,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            '비밀번호를 잊어버렸나요?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Signup Link
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '계정이 없으신가요? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.mutedForeground,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/signup'),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                '가입하기',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Terms
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '"로그인"하면 Fitkle의 이용약관에 동의하시게 됩니다. 귀하의\n개인정보 관리 방법과 관련해 쿠키 정책에 설명된\n쿠키 사용과 관련해 알 것입니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.mutedForeground,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
