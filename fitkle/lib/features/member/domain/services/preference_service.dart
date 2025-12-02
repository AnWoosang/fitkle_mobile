import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/features/member/domain/models/preference.dart';

/// 선호 카테고리 서비스 (싱글톤)
class PreferenceService {
  // 싱글톤 인스턴스
  static final PreferenceService _instance = PreferenceService._internal();

  factory PreferenceService() {
    return _instance;
  }

  PreferenceService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // 캐시된 선호 카테고리 목록
  List<Preference>? _cachedPreferences;

  /// 모든 활성화된 선호 카테고리 조회
  Future<List<Preference>> getPreferences({bool forceRefresh = false}) async {
    // 캐시가 있고 강제 새로고침이 아니면 캐시 반환
    if (_cachedPreferences != null && !forceRefresh) {
      return _cachedPreferences!;
    }

    try {
      final response = await _supabase
          .from('preference')
          .select()
          .eq('is_active', true)
          .order('sort_order');

      final preferences = (response as List)
          .map((json) => Preference.fromJson(json))
          .toList();

      // 캐시에 저장
      _cachedPreferences = preferences;

      return preferences;
    } catch (e) {
      print('Error fetching preferences: $e');
      rethrow;
    }
  }

  /// 특정 코드로 선호 카테고리 찾기
  Future<Preference?> getPreferenceByCode(String code) async {
    final preferences = await getPreferences();
    try {
      return preferences.firstWhere((preference) => preference.code == code);
    } catch (e) {
      return null;
    }
  }

  /// 사용자의 선호 카테고리 조회
  Future<List<Preference>> getMemberPreferences(String memberId) async {
    try {
      final response = await _supabase
          .from('member_preference')
          .select('preference_id, preference(*)')
          .eq('member_id', memberId);

      final preferences = (response as List)
          .map((item) => Preference.fromJson(item['preference']))
          .toList();

      return preferences;
    } catch (e) {
      print('Error fetching member preferences: $e');
      rethrow;
    }
  }

  /// 사용자의 선호 카테고리 업데이트 (RPC 트랜잭션)
  Future<void> updateMemberPreferences(String memberId, List<String> preferenceIds) async {
    try {
      // RPC 함수를 사용하여 트랜잭션으로 처리
      await _supabase.rpc('update_member_preferences', params: {
        'p_member_id': memberId,
        'p_preference_ids': preferenceIds,
      });
    } catch (e) {
      print('Error updating member preferences: $e');
      rethrow;
    }
  }

  /// 캐시 초기화
  void clearCache() {
    _cachedPreferences = null;
  }
}
