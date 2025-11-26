import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/core/error/exceptions.dart' as app_exceptions;
import 'package:fitkle/features/auth/data/models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  /// 이메일/비밀번호로 로그인
  Future<AuthUserModel> signInWithEmail(String email, String password);

  /// 이메일/비밀번호로 회원가입 (member 테이블에도 데이터 생성)
  Future<AuthUserModel> signUpWithEmail({
    required String email,
    required String password,
    String? nickname,
    String? location,
    String? nationality,
  });

  /// 로그아웃
  Future<void> signOut();

  /// 현재 로그인된 사용자 정보 조회 (member 테이블 포함)
  Future<AuthUserModel?> getCurrentAuthUser();

  /// 비밀번호 재설정 이메일 발송
  Future<void> resetPassword(String email);

  /// 비밀번호 변경
  Future<void> updatePassword(String newPassword);

  /// 이메일 변경
  Future<void> updateEmail(String newEmail);

  /// 세션 갱신
  Future<AuthUserModel?> refreshSession();

  /// Auth 상태 스트림
  Stream<AuthState> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<AuthUserModel> signInWithEmail(String email, String password) async {
    debugPrint('========== AUTH DATASOURCE ==========');
    debugPrint('[AuthDataSource] signInWithEmail 호출');
    debugPrint('[AuthDataSource] email: $email');
    debugPrint('[AuthDataSource] password: ${'*' * password.length} (${password.length}자)');

    try {
      debugPrint('[AuthDataSource] Supabase signInWithPassword 호출...');
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      debugPrint('[AuthDataSource] Supabase 응답 받음');
      debugPrint('[AuthDataSource] response.user: ${response.user}');
      debugPrint('[AuthDataSource] response.session: ${response.session != null ? 'exists' : 'null'}');

      if (response.user == null) {
        debugPrint('[AuthDataSource] user가 null입니다!');
        throw app_exceptions.AuthException('로그인에 실패했습니다');
      }

      debugPrint('[AuthDataSource] user.id: ${response.user!.id}');
      debugPrint('[AuthDataSource] user.email: ${response.user!.email}');
      debugPrint('[AuthDataSource] user.emailConfirmedAt: ${response.user!.emailConfirmedAt}');

      // member 테이블에서 추가 정보 조회
      debugPrint('[AuthDataSource] member 테이블 조회 시작...');
      final memberData = await _getMemberData(response.user!.id);
      debugPrint('[AuthDataSource] memberData: $memberData');

      final authUserModel = AuthUserModel.fromSupabaseUserWithMember(
        response.user!,
        memberData,
      );
      debugPrint('[AuthDataSource] AuthUserModel 생성 완료');
      debugPrint('[AuthDataSource] authUserModel.email: ${authUserModel.email}');
      debugPrint('[AuthDataSource] authUserModel.nickname: ${authUserModel.nickname}');

      return authUserModel;
    } on AuthException catch (e) {
      debugPrint('[AuthDataSource] Supabase AuthException: ${e.message}');
      debugPrint('[AuthDataSource] 파싱된 에러: ${_parseAuthError(e.message)}');
      throw app_exceptions.AuthException(_parseAuthError(e.message));
    } catch (e) {
      debugPrint('[AuthDataSource] Unknown Exception: $e');
      debugPrint('[AuthDataSource] Exception Type: ${e.runtimeType}');
      if (e is app_exceptions.AuthException) rethrow;
      throw app_exceptions.AuthException('로그인 실패: ${e.toString()}');
    }
  }

  @override
  Future<AuthUserModel> signUpWithEmail({
    required String email,
    required String password,
    String? nickname,
    String? location,
    String? nationality,
  }) async {
    try {
      // 1. Supabase Auth에 사용자 생성
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'nickname': nickname,
        },
      );

      if (response.user == null) {
        throw app_exceptions.AuthException('회원가입에 실패했습니다');
      }

      // 2. member 테이블에 프로필 생성
      await supabaseClient.from('member').insert({
        'id': response.user!.id,
        'email': email,
        'nickname': nickname,
        'location': location ?? 'Seoul',
        'nationality': nationality ?? 'KR',
        'is_verified': false,
      });

      // 3. 생성된 member 데이터 조회
      final memberData = await _getMemberData(response.user!.id);

      return AuthUserModel.fromSupabaseUserWithMember(
        response.user!,
        memberData,
      );
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(_parseAuthError(e.message));
    } on PostgrestException catch (e) {
      throw app_exceptions.ServerException('프로필 생성 실패: ${e.message}');
    } catch (e) {
      if (e is app_exceptions.AuthException) rethrow;
      if (e is app_exceptions.ServerException) rethrow;
      throw app_exceptions.AuthException('회원가입 실패: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw app_exceptions.AuthException('로그아웃 실패: ${e.toString()}');
    }
  }

  @override
  Future<AuthUserModel?> getCurrentAuthUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        return null;
      }

      // member 테이블에서 추가 정보 조회
      final memberData = await _getMemberData(user.id);

      return AuthUserModel.fromSupabaseUserWithMember(user, memberData);
    } catch (e) {
      throw app_exceptions.AuthException('사용자 정보 조회 실패: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(_parseAuthError(e.message));
    } catch (e) {
      throw app_exceptions.AuthException('비밀번호 재설정 이메일 발송 실패: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(_parseAuthError(e.message));
    } catch (e) {
      throw app_exceptions.AuthException('비밀번호 변경 실패: ${e.toString()}');
    }
  }

  @override
  Future<void> updateEmail(String newEmail) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(email: newEmail),
      );
    } on AuthException catch (e) {
      throw app_exceptions.AuthException(_parseAuthError(e.message));
    } catch (e) {
      throw app_exceptions.AuthException('이메일 변경 실패: ${e.toString()}');
    }
  }

  @override
  Future<AuthUserModel?> refreshSession() async {
    try {
      final response = await supabaseClient.auth.refreshSession();
      if (response.user == null) {
        return null;
      }

      final memberData = await _getMemberData(response.user!.id);
      return AuthUserModel.fromSupabaseUserWithMember(response.user!, memberData);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<AuthState> get authStateChanges => supabaseClient.auth.onAuthStateChange;

  /// member 테이블에서 사용자 데이터 조회
  Future<Map<String, dynamic>?> _getMemberData(String userId) async {
    debugPrint('[AuthDataSource] _getMemberData 호출');
    debugPrint('[AuthDataSource] userId: $userId');
    try {
      final response = await supabaseClient
          .from('member')
          .select()
          .eq('id', userId)
          .isFilter('deleted_at', null)
          .maybeSingle();
      debugPrint('[AuthDataSource] _getMemberData 성공: $response');
      return response;
    } catch (e) {
      debugPrint('[AuthDataSource] _getMemberData 실패: $e');
      debugPrint('[AuthDataSource] _getMemberData 에러 타입: ${e.runtimeType}');
      // member 테이블에 데이터가 없을 수 있음
      return null;
    }
  }

  /// Supabase Auth 에러 메시지를 한글로 변환
  String _parseAuthError(String message) {
    if (message.contains('Invalid login credentials')) {
      return '이메일 또는 비밀번호가 올바르지 않습니다';
    }
    if (message.contains('Email not confirmed')) {
      return '이메일 인증이 완료되지 않았습니다';
    }
    if (message.contains('User already registered')) {
      return '이미 등록된 이메일입니다';
    }
    if (message.contains('Password should be at least')) {
      return '비밀번호는 최소 6자 이상이어야 합니다';
    }
    if (message.contains('Email rate limit exceeded')) {
      return '이메일 발송 한도를 초과했습니다. 잠시 후 다시 시도해주세요';
    }
    if (message.contains('Invalid email')) {
      return '유효하지 않은 이메일 형식입니다';
    }
    return message;
  }
}
