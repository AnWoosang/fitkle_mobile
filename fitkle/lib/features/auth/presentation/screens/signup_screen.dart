import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/signup_progress_bar.dart';
import 'package:fitkle/features/auth/domain/models/signup_data.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/steps/method_selection_step.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/steps/basic_info_step.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/steps/verification_step.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/steps/additional_info_step.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/steps/completion_step.dart';

enum SignupStep {
  method,
  info,
  emailVerify,
  additionalInfo,
  complete,
}

enum SignupMethod {
  email,
  google,
  kakao,
  apple,
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignupStep _currentStep = SignupStep.method;
  SignupData _signupData = SignupData();

  void _handleMethodSelected(SignupMethod method) {
    setState(() {
      _signupData = _signupData.copyWith(signupMethod: method);
      _currentStep = SignupStep.info;
    });

    // Mock social login data
    if (method != SignupMethod.email) {
      setState(() {
        _signupData = _signupData.copyWith(
          name: method == SignupMethod.google ? 'John Doe' : '김철수',
          email: method == SignupMethod.google ? 'john@gmail.com' : 'user@kakao.com',
        );
      });
    }
  }

  void _handleBasicInfoSubmit(SignupData data) {
    setState(() {
      _signupData = data;
      _currentStep = SignupStep.emailVerify;
    });
  }

  void _handleVerificationSubmit(SignupData data) {
    setState(() {
      _signupData = data;
      _currentStep = SignupStep.additionalInfo;
    });
  }

  void _handleAdditionalInfoSubmit(SignupData data) {
    setState(() {
      _signupData = data;
      _currentStep = SignupStep.complete;
    });

    // Navigate to home after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  void _handleBackStep() {
    setState(() {
      switch (_currentStep) {
        case SignupStep.info:
          _currentStep = SignupStep.method;
          break;
        case SignupStep.emailVerify:
          _currentStep = SignupStep.info;
          break;
        case SignupStep.additionalInfo:
          _currentStep = SignupStep.emailVerify;
          break;
        default:
          context.go('/login');
      }
    });
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case SignupStep.method:
        return MethodSelectionStep(
          onMethodSelected: _handleMethodSelected,
        );
      case SignupStep.info:
        return BasicInfoStep(
          initialData: _signupData,
          onSubmit: _handleBasicInfoSubmit,
        );
      case SignupStep.emailVerify:
        return VerificationStep(
          initialData: _signupData,
          onSubmit: _handleVerificationSubmit,
        );
      case SignupStep.additionalInfo:
        return AdditionalInfoStep(
          initialData: _signupData,
          onSubmit: _handleAdditionalInfoSubmit,
        );
      case SignupStep.complete:
        return const CompletionStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            if (_currentStep != SignupStep.complete) _buildHeader(),

            // Progress Bar
            if (_currentStep != SignupStep.complete && _currentStep != SignupStep.method)
              SignupProgressBar(currentStep: _currentStep),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: _buildCurrentStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackStep,
          ),
          const SizedBox(width: 8),
          const Text(
            '뒤로',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
