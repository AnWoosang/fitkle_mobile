import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 환경변수 설정 클래스
/// .env 파일에서 환경변수를 로드하고 접근하는 중앙화된 클래스
class EnvConfig {
  // Supabase
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Google Maps
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  // App
  static String get appName => dotenv.env['APP_NAME'] ?? 'Fitkle';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  // MCP Configuration
  static String get supabaseAccessToken => dotenv.env['SUPABASE_ACCESS_TOKEN'] ?? '';
  static String get supabaseProjectRef => dotenv.env['SUPABASE_PROJECT_REF'] ?? '';

  // Firebase (Optional)
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

  // Social Login (Optional)
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  static String get kakaoApiKey => dotenv.env['KAKAO_API_KEY'] ?? '';

  // Helper methods
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';

  /// 환경변수 초기화
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
      print('✅ Environment variables loaded successfully');
    } catch (e) {
      print('⚠️ Error loading .env file: $e');
      print('⚠️ Using default values');
    }
  }

  /// 환경변수 유효성 검사
  static void validate() {
    final errors = <String>[];

    if (supabaseUrl.isEmpty) {
      errors.add('SUPABASE_URL is not set');
    }

    if (supabaseAnonKey.isEmpty) {
      errors.add('SUPABASE_ANON_KEY is not set');
    }

    if (errors.isNotEmpty) {
      print('⚠️ Environment validation warnings:');
      for (final error in errors) {
        print('  - $error');
      }
    } else {
      print('✅ Environment variables validated successfully');
    }
  }

  /// 디버그용 환경변수 출력 (민감한 정보 마스킹)
  static void printDebugInfo() {
    if (!isProduction) {
      print('🔧 Environment Configuration:');
      print('  - Environment: $environment');
      print('  - App Name: $appName');
      print('  - App Version: $appVersion');
      print('  - Supabase URL: ${_maskString(supabaseUrl)}');
      print('  - Supabase Key: ${_maskString(supabaseAnonKey)}');
      print('  - MCP Access Token: ${_maskString(supabaseAccessToken)}');
      print('  - MCP Project Ref: $supabaseProjectRef');
      print('  - Google Maps Key: ${_maskString(googleMapsApiKey)}');
    }
  }

  /// 문자열 마스킹 (디버그용)
  static String _maskString(String value) {
    if (value.isEmpty) return '[NOT SET]';
    if (value.length <= 8) return '****';
    return '${value.substring(0, 4)}...${value.substring(value.length - 4)}';
  }
}
