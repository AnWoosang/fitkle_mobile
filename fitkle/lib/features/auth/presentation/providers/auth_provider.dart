import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitkle/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitkle/features/auth/domain/services/auth_service.dart';
import 'package:fitkle/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fitkle/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fitkle/core/config/supabase_client.dart';
import 'package:fitkle/core/network/network_info.dart';

// ============================================================================
// DEPENDENCY INJECTION - Auth Feature
// ============================================================================

// Core Dependencies
final _authSupabaseClientProvider = Provider((ref) => supabaseClient);
final _authNetworkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

// Data Sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(_authSupabaseClientProvider));
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    networkInfo: ref.watch(_authNetworkInfoProvider),
    supabaseClient: ref.watch(_authSupabaseClientProvider),
  );
});

// Services
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(authRepositoryProvider));
});

// ============================================================================
// STATE MANAGEMENT
// ============================================================================

/// 인증 상태
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// 인증 사용자 상태
class AuthState {
  final AuthUserEntity? user;
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthUserEntity? user,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  /// 로그인 성공 상태
  factory AuthState.authenticated(AuthUserEntity user) {
    return AuthState(
      user: user,
      status: AuthStatus.authenticated,
    );
  }

  /// 로그아웃 상태
  factory AuthState.unauthenticated() {
    return const AuthState(
      user: null,
      status: AuthStatus.unauthenticated,
    );
  }

  /// 로딩 상태
  factory AuthState.loading() {
    return const AuthState(
      status: AuthStatus.loading,
    );
  }

  /// 에러 상태
  factory AuthState.error(String message) {
    return AuthState(
      status: AuthStatus.error,
      errorMessage: message,
    );
  }
}

/// 인증 상태 관리 Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  /// 로그인 상태 확인
  bool get isLoggedIn => _authService.isLoggedIn;

  /// 앱 시작 시 현재 사용자 로드
  Future<void> loadCurrentUser() async {
    debugPrint('========== LOAD CURRENT USER ==========');
    debugPrint('[AuthNotifier] loadCurrentUser 호출');
    state = AuthState.loading();

    final result = await _authService.getCurrentAuthUser();

    result.fold(
      (failure) {
        debugPrint('[AuthNotifier] 사용자 로드 실패: ${failure.message}');
        state = AuthState.unauthenticated();
      },
      (user) {
        if (user != null) {
          debugPrint('[AuthNotifier] 사용자 로드 성공: ${user.email}');
          state = AuthState.authenticated(user);
        } else {
          debugPrint('[AuthNotifier] 사용자 없음');
          state = AuthState.unauthenticated();
        }
      },
    );
    debugPrint('[AuthNotifier] 최종 상태: ${state.status}, user: ${state.user?.email}');
  }

  /// 이메일/비밀번호로 로그인
  Future<bool> signInWithEmail(String email, String password) async {
    debugPrint('========== AUTH PROVIDER ==========');
    debugPrint('[AuthProvider] signInWithEmail 호출');
    debugPrint('[AuthProvider] email: $email');
    debugPrint('[AuthProvider] password: ${'*' * password.length} (${password.length}자)');

    state = AuthState.loading();
    debugPrint('[AuthProvider] 상태 변경: loading');

    final result = await _authService.signInWithEmail(email, password);

    return result.fold(
      (failure) {
        debugPrint('[AuthProvider] 로그인 실패: ${failure.message}');
        state = AuthState.error(failure.message);
        return false;
      },
      (user) {
        debugPrint('[AuthProvider] 로그인 성공!');
        debugPrint('[AuthProvider] user.id: ${user.id}');
        debugPrint('[AuthProvider] user.email: ${user.email}');
        debugPrint('[AuthProvider] user.nickname: ${user.nickname}');
        state = AuthState.authenticated(user);
        return true;
      },
    );
  }

  /// 이메일/비밀번호로 회원가입
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? nickname,
    String? location,
    String? nationality,
  }) async {
    state = AuthState.loading();

    final result = await _authService.signUpWithEmail(
      email: email,
      password: password,
      nickname: nickname,
      location: location,
      nationality: nationality,
    );

    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (user) {
        state = AuthState.authenticated(user);
        return true;
      },
    );
  }

  /// 로그아웃
  Future<bool> signOut() async {
    state = AuthState.loading();

    final result = await _authService.signOut();

    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (_) {
        state = AuthState.unauthenticated();
        return true;
      },
    );
  }

  /// 비밀번호 재설정 이메일 발송
  Future<bool> resetPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _authService.resetPassword(email);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return true;
      },
    );
  }

  /// 비밀번호 변경
  Future<bool> updatePassword(String newPassword) async {
    final result = await _authService.updatePassword(newPassword);

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (_) => true,
    );
  }

  /// 세션 갱신
  Future<void> refreshSession() async {
    final result = await _authService.refreshSession();

    result.fold(
      (failure) {
        state = AuthState.unauthenticated();
      },
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = AuthState.unauthenticated();
        }
      },
    );
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ============================================================================
// STATE PROVIDERS
// ============================================================================

/// 인증 상태 Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

/// 현재 사용자 Provider (편의용)
final currentUserProvider = Provider<AuthUserEntity?>((ref) {
  return ref.watch(authProvider).user;
});

/// 로그인 상태 Provider (편의용)
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
