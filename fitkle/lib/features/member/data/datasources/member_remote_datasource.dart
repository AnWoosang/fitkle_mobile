import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/features/member/data/models/member_model.dart';

abstract class MemberRemoteDataSource {
  Future<MemberModel> getMemberById(String userId);
  Future<MemberModel> updateMember(MemberModel user);
  Future<void> updateAvatar(String userId, String avatarUrl);
  Future<List<MemberModel>> searchMembers(String query);
  Future<bool> checkNicknameAvailability(String nickname);
  Future<bool> checkEmailAvailability(String email);
}

class MemberRemoteDataSourceImpl implements MemberRemoteDataSource {
  final SupabaseClient supabaseClient;

  MemberRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<MemberModel> getMemberById(String userId) async {
    try {
      final response = await supabaseClient
          .from('user')
          .select()
          .eq('id', userId)
          .single();

      return MemberModel.fromJson(response);
    } catch (e) {
      throw NotFoundException('User not found: ${e.toString()}');
    }
  }

  @override
  Future<MemberModel> updateMember(MemberModel user) async {
    try {
      final response = await supabaseClient
          .from('user')
          .update(user.toJson())
          .eq('id', user.id)
          .select()
          .single();

      return MemberModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<void> updateAvatar(String userId, String avatarUrl) async {
    try {
      await supabaseClient
          .from('user')
          .update({'avatar_url': avatarUrl})
          .eq('id', userId);
    } catch (e) {
      throw ServerException('Failed to update avatar: ${e.toString()}');
    }
  }

  @override
  Future<List<MemberModel>> searchMembers(String query) async {
    try {
      final response = await supabaseClient
          .from('user')
          .select()
          .ilike('name', '%$query%')
          .limit(20);

      return (response as List).map((json) => MemberModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to search users: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkNicknameAvailability(String nickname) async {
    try {
      final response = await supabaseClient
          .from('user')
          .select('name')
          .eq('name', nickname)
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
          .from('user')
          .select('email')
          .eq('email', email)
          .maybeSingle();

      // null이면 사용 가능, 데이터가 있으면 이미 사용 중
      return response == null;
    } catch (e) {
      throw ServerException('Failed to check email availability: ${e.toString()}');
    }
  }
}
