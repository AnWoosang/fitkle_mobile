import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitkle/features/auth/domain/repositories/auth_repository.dart';

/// Auth 도메인 서비스
///
/// 인증과 관련된 모든 비즈니스 로직을 처리합니다.
/// Repository 패턴을 통해 데이터 계층과 분리되어 있습니다.
class AuthService {
  final AuthRepository _repository;

  AuthService(this._repository);

  /// 로그인 상태 확인
  bool get isLoggedIn => _repository.isLoggedIn;

  /// 이메일/비밀번호로 로그인
  Future<Either<Failure, AuthUserEntity>> signInWithEmail(
    String email,
    String password,
  ) async {
    debugPrint('========== AUTH SERVICE ==========');
    debugPrint('[AuthService] signInWithEmail 호출');
    debugPrint('[AuthService] email: $email');
    debugPrint('[AuthService] password: ${'*' * password.length} (${password.length}자)');
    debugPrint('[AuthService] Repository 호출 시작...');

    final result = await _repository.signInWithEmail(email, password);

    result.fold(
      (failure) => debugPrint('[AuthService] Repository 실패: ${failure.message}'),
      (user) => debugPrint('[AuthService] Repository 성공: ${user.email}'),
    );

    return result;
  }

  /// 이메일/비밀번호로 회원가입
  Future<Either<Failure, AuthUserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? nickname,
    String? location,
    String? nationality,
  }) async {
    return await _repository.signUpWithEmail(
      email: email,
      password: password,
      nickname: nickname,
      location: location,
      nationality: nationality,
    );
  }

  /// 로그아웃
  Future<Either<Failure, void>> signOut() async {
    return await _repository.signOut();
  }

  /// 현재 로그인된 사용자 조회
  Future<Either<Failure, AuthUserEntity?>> getCurrentAuthUser() async {
    return await _repository.getCurrentAuthUser();
  }

  /// 비밀번호 재설정 이메일 발송
  Future<Either<Failure, void>> resetPassword(String email) async {
    return await _repository.resetPassword(email);
  }

  /// 비밀번호 변경
  Future<Either<Failure, void>> updatePassword(String newPassword) async {
    return await _repository.updatePassword(newPassword);
  }

  /// 이메일 변경
  Future<Either<Failure, void>> updateEmail(String newEmail) async {
    return await _repository.updateEmail(newEmail);
  }

  /// 세션 갱신
  Future<Either<Failure, AuthUserEntity?>> refreshSession() async {
    return await _repository.refreshSession();
  }
}
