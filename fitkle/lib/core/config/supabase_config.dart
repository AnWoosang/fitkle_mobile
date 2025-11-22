import 'env_config.dart';

/// Supabase 설정 클래스
/// 환경변수에서 Supabase 설정을 가져옵니다
class SupabaseConfig {
  /// Supabase URL (.env에서 로드)
  static String get supabaseUrl => EnvConfig.supabaseUrl;

  /// Supabase Anon Key (.env에서 로드)
  static String get supabaseAnonKey => EnvConfig.supabaseAnonKey;

  /// 설정 유효성 검사
  static bool get isValid {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }

  /// 디버그 정보 출력
  static void printDebugInfo() {
    print('🔐 Supabase Configuration:');
    print('  URL: ${_maskUrl(supabaseUrl)}');
    print('  Key: ${_maskKey(supabaseAnonKey)}');
    print('  Valid: $isValid');
  }

  static String _maskUrl(String url) {
    if (url.isEmpty) return '[NOT SET]';
    try {
      final uri = Uri.parse(url);
      return '${uri.scheme}://${uri.host.substring(0, 4)}...${uri.host.substring(uri.host.length - 4)}';
    } catch (_) {
      return '[INVALID URL]';
    }
  }

  static String _maskKey(String key) {
    if (key.isEmpty) return '[NOT SET]';
    if (key.length <= 8) return '****';
    return '${key.substring(0, 4)}...${key.substring(key.length - 4)}';
  }
}
