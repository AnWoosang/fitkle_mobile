import 'package:fitkle/features/member/domain/models/interest.dart';
import 'package:fitkle/features/auth/presentation/screens/signup_screen.dart';

/// Model class to hold all signup data across different steps
class SignupData {
  // Basic info
  String name;
  String email;
  String password;
  String passwordConfirm;
  bool agreedToTerms;

  // Signup method
  SignupMethod signupMethod;

  // Verification
  String phoneNumber;
  String emailCode;
  String phoneCode;
  bool isEmailVerified;
  bool isPhoneVerified;

  // Additional info
  String nationality;
  String? language;
  String? gender; // 'MALE', 'FEMALE', 'PREFER_NOT_TO_SAY'
  List<Interest> selectedInterests;

  SignupData({
    this.name = '',
    this.email = '',
    this.password = '',
    this.passwordConfirm = '',
    this.agreedToTerms = false,
    this.signupMethod = SignupMethod.email,
    this.phoneNumber = '',
    this.emailCode = '',
    this.phoneCode = '',
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.nationality = '',
    this.language,
    this.gender,
    this.selectedInterests = const [],
  });

  SignupData copyWith({
    String? name,
    String? email,
    String? password,
    String? passwordConfirm,
    bool? agreedToTerms,
    SignupMethod? signupMethod,
    String? phoneNumber,
    String? emailCode,
    String? phoneCode,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? nationality,
    String? language,
    String? gender,
    List<Interest>? selectedInterests,
  }) {
    return SignupData(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      signupMethod: signupMethod ?? this.signupMethod,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailCode: emailCode ?? this.emailCode,
      phoneCode: phoneCode ?? this.phoneCode,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      nationality: nationality ?? this.nationality,
      language: language ?? this.language,
      gender: gender ?? this.gender,
      selectedInterests: selectedInterests ?? this.selectedInterests,
    );
  }
}
