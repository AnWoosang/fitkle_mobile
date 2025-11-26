import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  /// 이메일/비밀번호로 로그인
  Future<Either<Failure, AuthUserEntity>> signInWithEmail(
    String email,
    String password,
  );

  /// 이메일/비밀번호로 회원가입
  Future<Either<Failure, AuthUserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? nickname,
    String? location,
    String? nationality,
  });

  /// 로그아웃
  Future<Either<Failure, void>> signOut();

  /// 현재 로그인된 사용자 조회
  Future<Either<Failure, AuthUserEntity?>> getCurrentAuthUser();

  /// 비밀번호 재설정 이메일 발송
  Future<Either<Failure, void>> resetPassword(String email);

  /// 비밀번호 변경
  Future<Either<Failure, void>> updatePassword(String newPassword);

  /// 이메일 변경
  Future<Either<Failure, void>> updateEmail(String newEmail);

  /// 세션 갱신
  Future<Either<Failure, AuthUserEntity?>> refreshSession();

  /// 로그인 상태 확인
  bool get isLoggedIn;
}
