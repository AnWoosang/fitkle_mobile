import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/core/utils/validators.dart';
import 'package:fitkle/shared/widgets/app_text_button.dart';
import 'package:fitkle/shared/widgets/app_logo.dart';
import 'package:fitkle/features/auth/presentation/widgets/login/social_login_buttons_section.dart';
import 'package:fitkle/features/auth/presentation/widgets/login/email_login_form.dart';
import 'package:fitkle/features/auth/presentation/widgets/login/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final emailError = Validators.validateEmail(_emailController.text);
    final passwordValidation = Validators.validatePassword(_passwordController.text);

    setState(() {
      _isFormValid = emailError == null && passwordValidation.isValid;
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

    setState(() => _isLoading = true);

    // TODO: Implement Supabase authentication
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/home');
    }
  }

  void _handleSocialLogin(String provider) {
    // TODO: Implement social login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider 로그인 준비 중입니다')),
    );
  }


  @override
  Widget build(BuildContext context) {
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
                          isLoading: _isLoading,
                          isFormValid: _isFormValid,
                          onPressed: _handleLogin,
                        ),

                        const SizedBox(height: 24),

                        // Forgot Password
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                            },
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
                              '"로그인"하면 Meetup의 이용약관에 동의하시게 됩니다. 귀하의\n개인정보 관리 방법과 관련해 쿠키 정책에 설명된\n쿠키 사용과 관련해 알 것입니다.',
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
