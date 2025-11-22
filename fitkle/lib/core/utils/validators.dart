import 'package:fitkle/features/member/presentation/providers/member_provider.dart';
import 'package:fitkle/core/di/providers.dart';

/// 이메일 및 비밀번호 유효성 검증 유틸리티
class Validators {
  /// 닉네임 유효성 검증
  ///
  /// 반환값: 에러 메시지 (유효한 경우 null)
  static String? validateNickname(String? nickname) {
    if (nickname == null || nickname.isEmpty) return null;

    if (nickname.length > 20) {
      return '닉네임은 20자 이하로 입력해주세요';
    }

    // 영문, 숫자, 한글, 언더스코어(_), 마침표(.)만 허용
    final nicknameRegex = RegExp(r'^[a-zA-Z0-9가-힣_.]+$');
    if (!nicknameRegex.hasMatch(nickname)) {
      return '특수문자는 사용하실 수 없습니다';
    }

    return null;
  }

  /// 닉네임 중복 검사 (MemberService 사용)
  ///
  /// 반환값: Future\<bool\> (사용 가능하면 true, 실패 시 false)
  static Future<bool> checkNicknameAvailability(String nickname) async {
    final container = globalProviderContainer;
    final memberService = container.read(memberServiceProvider);
    final result = await memberService.checkNicknameAvailability(nickname);

    return result.fold(
      (failure) => false, // 에러 발생 시 안전하게 false 반환
      (isAvailable) => isAvailable,
    );
  }

  /// 이메일 유효성 검증
  ///
  /// 반환값: 에러 메시지 (유효한 경우 null)
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return null;

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      return '이메일 주소가 올바르지 않아요';
    }

    return null;
  }

  /// 이메일 중복 검사 (MemberService 사용)
  ///
  /// 반환값: Future\<bool\> (사용 가능하면 true, 실패 시 false)
  static Future<bool> checkEmailAvailability(String email) async {
    final container = globalProviderContainer;
    final memberService = container.read(memberServiceProvider);
    final result = await memberService.checkEmailAvailability(email);

    return result.fold(
      (failure) => false, // 에러 발생 시 안전하게 false 반환
      (isAvailable) => isAvailable,
    );
  }

  /// 비밀번호 유효성 검증 결과
  static PasswordValidationResult validatePassword(String? password) {
    final errors = <String>[];

    if (password == null || password.isEmpty) {
      return PasswordValidationResult(isValid: false, errors: []);
    }

    if (password.length < 8) {
      errors.add('8자 이상이어야 합니다');
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      errors.add('영문자가 포함되어야 합니다');
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      errors.add('숫자가 포함되어야 합니다');
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>~]').hasMatch(password)) {
      errors.add('특수문자가 1자이상 포함되어야 합니다');
    }

    return PasswordValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

/// 비밀번호 검증 결과
class PasswordValidationResult {
  final bool isValid;
  final List<String> errors;

  const PasswordValidationResult({
    required this.isValid,
    required this.errors,
  });
}
