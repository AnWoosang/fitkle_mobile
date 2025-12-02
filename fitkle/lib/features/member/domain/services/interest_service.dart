import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/features/member/domain/models/interest.dart';

/// 관심사 서비스 (싱글톤)
class InterestService {
  // 싱글톤 인스턴스
  static final InterestService _instance = InterestService._internal();

  factory InterestService() {
    return _instance;
  }

  InterestService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // 캐시된 관심사 목록
  List<Interest>? _cachedInterests;

  /// 모든 활성화된 관심사 조회
  Future<List<Interest>> getInterests({bool forceRefresh = false}) async {
    // 캐시가 있고 강제 새로고침이 아니면 캐시 반환
    if (_cachedInterests != null && !forceRefresh) {
      return _cachedInterests!;
    }

    try {
      final response = await _supabase
          .from('interests')
          .select()
          .eq('is_active', true)
          .order('sort_order');

      final interests = (response as List)
          .map((json) => Interest.fromJson(json))
          .toList();

      // 캐시에 저장
      _cachedInterests = interests;

      return interests;
    } catch (e) {
      print('Error fetching interests: $e');
      rethrow;
    }
  }

  /// 특정 코드로 관심사 찾기
  Future<Interest?> getInterestByCode(String code) async {
    final interests = await getInterests();
    try {
      return interests.firstWhere((interest) => interest.code == code);
    } catch (e) {
      return null;
    }
  }

  /// 사용자의 관심사 조회
  Future<List<Interest>> getMemberInterests(String userId) async {
    try {
      final response = await _supabase
          .from('member_interests')
          .select('interest_id, interests(*)')
          .eq('user_id', userId);

      final interests = (response as List)
          .map((item) => Interest.fromJson(item['interests']))
          .toList();

      return interests;
    } catch (e) {
      print('Error fetching member interests: $e');
      rethrow;
    }
  }

  /// 사용자의 관심사 업데이트 (RPC 트랜잭션)
  Future<void> updateMemberInterests(String memberId, List<String> interestIds) async {
    try {
      // RPC 함수를 사용하여 트랜잭션으로 처리
      await _supabase.rpc('update_member_interests', params: {
        'p_member_id': memberId,
        'p_interest_ids': interestIds,
      });
    } catch (e) {
      print('Error updating member interests: $e');
      rethrow;
    }
  }

  /// 캐시 초기화
  void clearCache() {
    _cachedInterests = null;
  }
}
