import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

/// Supabase 클라이언트 싱글톤
///
/// 사용법:
/// ```dart
/// // 일반 쿼리 (RLS 적용됨)
/// final response = await supabaseClient.from('users').select();
///
/// // 인증
/// await supabaseClient.auth.signInWithPassword(email: email, password: password);
///
/// // 인증 후 자동으로 JWT 토큰이 모든 요청에 포함됨
/// final myData = await supabaseClient.from('my_table').select();
/// ```
class SupabaseClientManager {
  static SupabaseClient? _instance;

  /// Supabase 클라이언트 초기화
  static Future<void> initialize() async {
    if (_instance != null) {
      print('⚠️ Supabase already initialized');
      return;
    }

    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );

      _instance = Supabase.instance.client;
      print('✅ Supabase initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize Supabase: $e');
      rethrow;
    }
  }

  /// Supabase 클라이언트 인스턴스
  static SupabaseClient get instance {
    if (_instance == null) {
      throw Exception(
        'Supabase not initialized. Call SupabaseClientManager.initialize() first.',
      );
    }
    return _instance!;
  }

  /// 현재 사용자
  static User? get currentUser => instance.auth.currentUser;

  /// 인증 상태 스트림
  static Stream<AuthState> get authStateChanges => instance.auth.onAuthStateChange;

  /// 로그인 여부
  static bool get isAuthenticated => currentUser != null;
}

/// 전역 Supabase 클라이언트 (편의를 위한 getter)
SupabaseClient get supabaseClient => SupabaseClientManager.instance;
