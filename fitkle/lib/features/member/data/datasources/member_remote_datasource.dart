import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/features/member/data/models/member_model.dart';

abstract class MemberRemoteDataSource {
  Future<MemberModel> getMemberById(String memberId);
  Future<MemberModel> getMemberByEmail(String email);
  Future<MemberModel> createMember(MemberModel member);
  Future<MemberModel> updateMember(MemberModel member);
  Future<void> updateAvatar(String memberId, String avatarUrl);
  Future<void> softDeleteMember(String memberId);
  Future<List<MemberModel>> searchMembers(String query);
  Future<bool> checkNicknameAvailability(String nickname);
  Future<bool> checkEmailAvailability(String email);
  Future<List<MemberModel>> getAllMembers({int limit = 50, int offset = 0});
}

class MemberRemoteDataSourceImpl implements MemberRemoteDataSource {
  final SupabaseClient supabaseClient;

  MemberRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<MemberModel> getMemberById(String memberId) async {
    try {
      final response = await supabaseClient
          .from('member')
          .select('''
            *,
            interests:member_interests(
              interest:interests(*)
            )
          ''')
          .eq('id', memberId)
          .isFilter('deleted_at', null)
          .single();

      // Transform nested interests structure to flat array
      final Map<String, dynamic> transformedResponse = Map.from(response);
      if (response['interests'] != null && response['interests'] is List) {
        transformedResponse['interests'] = (response['interests'] as List)
            .map((mi) => mi['interest'])
            .where((i) => i != null)
            .toList();
      }

      return MemberModel.fromJson(transformedResponse);
    } catch (e) {
      throw NotFoundException('Member not found: ${e.toString()}');
    }
  }

  @override
  Future<MemberModel> getMemberByEmail(String email) async {
    try {
      final response = await supabaseClient
          .from('member')
          .select('''
            *,
            interests:member_interests(
              interest:interests(*)
            )
          ''')
          .eq('email', email)
          .isFilter('deleted_at', null)
          .single();

      // Transform nested interests structure to flat array
      final Map<String, dynamic> transformedResponse = Map.from(response);
      if (response['interests'] != null && response['interests'] is List) {
        transformedResponse['interests'] = (response['interests'] as List)
            .map((mi) => mi['interest'])
            .where((i) => i != null)
            .toList();
      }

      return MemberModel.fromJson(transformedResponse);
    } catch (e) {
      throw NotFoundException('Member not found: ${e.toString()}');
    }
  }

  @override
  Future<MemberModel> createMember(MemberModel member) async {
    try {
      final response = await supabaseClient
          .from('member')
          .insert(member.toInsertJson())
          .select()
          .single();

      return MemberModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to create member: ${e.toString()}');
    }
  }

  @override
  Future<MemberModel> updateMember(MemberModel member) async {
    try {
      final response = await supabaseClient
          .from('member')
          .update(member.toUpdateJson())
          .eq('id', member.id)
          .select()
          .single();

      return MemberModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to update member: ${e.toString()}');
    }
  }

  @override
  Future<void> updateAvatar(String memberId, String avatarUrl) async {
    try {
      await supabaseClient
          .from('member')
          .update({'avatar_url': avatarUrl})
          .eq('id', memberId);
    } catch (e) {
      throw ServerException('Failed to update avatar: ${e.toString()}');
    }
  }

  @override
  Future<void> softDeleteMember(String memberId) async {
    try {
      await supabaseClient
          .from('member')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', memberId);
    } catch (e) {
      throw ServerException('Failed to delete member: ${e.toString()}');
    }
  }

  @override
  Future<List<MemberModel>> searchMembers(String query) async {
    try {
      final response = await supabaseClient
          .from('member')
          .select('''
            *,
            interests:member_interests(
              interest:interests(*)
            )
          ''')
          .or('nickname.ilike.%$query%,email.ilike.%$query%')
          .isFilter('deleted_at', null)
          .limit(20);

      // Transform nested interests structure to flat array for each member
      return (response as List).map((memberJson) {
        final Map<String, dynamic> transformed = Map.from(memberJson);
        if (memberJson['interests'] != null && memberJson['interests'] is List) {
          transformed['interests'] = (memberJson['interests'] as List)
              .map((mi) => mi['interest'])
              .where((i) => i != null)
              .toList();
        }
        return MemberModel.fromJson(transformed);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to search members: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkNicknameAvailability(String nickname) async {
    try {
      final response = await supabaseClient
          .from('member')
          .select('nickname')
          .eq('nickname', nickname)
          .isFilter('deleted_at', null)
          .maybeSingle();

      // null이면 사용 가능, 데이터가 있으면 이미 사용 중
      return response == null;
    } catch (e) {
      throw ServerException('Failed to check nickname availability: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkEmailAvailability(String email) async {
    try {
      final response = await supabaseClient
          .from('member')
          .select('email')
          .eq('email', email)
          .isFilter('deleted_at', null)
          .maybeSingle();

      // null이면 사용 가능, 데이터가 있으면 이미 사용 중
      return response == null;
    } catch (e) {
      throw ServerException('Failed to check email availability: ${e.toString()}');
    }
  }

  @override
  Future<List<MemberModel>> getAllMembers({int limit = 50, int offset = 0}) async {
    try {
      final response = await supabaseClient
          .from('member')
          .select('''
            *,
            interests:member_interests(
              interest:interests(*)
            )
          ''')
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      // Transform nested interests structure to flat array for each member
      return (response as List).map((memberJson) {
        final Map<String, dynamic> transformed = Map.from(memberJson);
        if (memberJson['interests'] != null && memberJson['interests'] is List) {
          transformed['interests'] = (memberJson['interests'] as List)
              .map((mi) => mi['interest'])
              .where((i) => i != null)
              .toList();
        }
        return MemberModel.fromJson(transformed);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to get members: ${e.toString()}');
    }
  }
}
