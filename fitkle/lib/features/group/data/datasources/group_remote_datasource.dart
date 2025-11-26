import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/utils/logger.dart';
import 'package:fitkle/features/group/data/models/group_model.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupModel>> getGroups({
    String? category,
    String? searchQuery,
    int limit = 30,
    int offset = 0,
  });
  Future<GroupModel> getGroupById(String groupId);
  Future<List<GroupModel>> getGroupsByHost(String hostId);
  Future<List<GroupModel>> getGroupsByMember(String memberId);
  Future<GroupModel> createGroup(GroupModel group);
  Future<GroupModel> updateGroup(GroupModel group);
  Future<void> deleteGroup(String groupId);
  Future<void> joinGroup(String groupId, String userId);
  Future<void> leaveGroup(String groupId, String userId);
  Future<void> incrementViewCount(String groupId);
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final SupabaseClient supabaseClient;

  GroupRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<GroupModel>> getGroups({
    String? category,
    String? searchQuery,
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      // Build query parameters for logging
      // Note: category parameter is already a UUID from GroupCategoryService conversion
      final params = <String, dynamic>{
        'table': 'group',
        'select': '*',
        if (category != null && category != 'all') 'group_category_id': category,
        if (searchQuery != null && searchQuery.isNotEmpty) 'name.ilike': '%$searchQuery%',
        'order': 'created_at.desc',
        'limit': limit,
        'offset': offset,
      };

      Logger.request(
        'GET',
        'Supabase REST API /rest/v1/group',
        data: params,
      );

      var query = supabaseClient.from('group').select();

      if (category != null && category != 'all') {
        query = query.eq('group_category_id', category);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.ilike('name', '%$searchQuery%');
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      Logger.response(
        200,
        'Supabase REST API /rest/v1/group',
        data: {
          'count': (response as List).length,
          'offset': offset,
          'limit': limit,
        },
      );

      return response.map((json) => GroupModel.fromJson(json)).toList();
    } catch (e) {
      Logger.error(
        'Failed to fetch groups from Supabase',
        tag: 'GroupDataSource',
        error: e,
      );
      throw ServerException('Failed to fetch groups: ${e.toString()}');
    }
  }

  @override
  Future<GroupModel> getGroupById(String groupId) async {
    try {
      final response = await supabaseClient
          .from('group')
          .select()
          .eq('id', groupId)
          .single();

      return GroupModel.fromJson(response);
    } catch (e) {
      throw NotFoundException('Group not found: ${e.toString()}');
    }
  }

  @override
  Future<List<GroupModel>> getGroupsByHost(String hostId) async {
    try {
      final response = await supabaseClient
          .from('group')
          .select()
          .eq('host_id', hostId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => GroupModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch groups by host: ${e.toString()}');
    }
  }

  @override
  Future<List<GroupModel>> getGroupsByMember(String memberId) async {
    try {
      Logger.info(
        'Fetching groups for member: $memberId',
        tag: 'GroupDataSource',
      );

      // 1. group_member 테이블에서 해당 멤버가 속한 그룹 ID 조회
      final memberResponse = await supabaseClient
          .from('group_member')
          .select('group_id')
          .eq('member_id', memberId)
          .isFilter('deleted_at', null);

      final groupIds = (memberResponse as List)
          .map((m) => m['group_id'] as String)
          .toList();

      Logger.debug(
        'Found ${groupIds.length} group memberships for member',
        tag: 'GroupDataSource',
      );

      if (groupIds.isEmpty) {
        return [];
      }

      // 2. group 테이블에서 해당 그룹들 조회 (최대 20개)
      final groupResponse = await supabaseClient
          .from('group')
          .select()
          .inFilter('id', groupIds)
          .isFilter('deleted_at', null)
          .limit(20);

      Logger.response(
        200,
        'Supabase REST API - getGroupsByMember',
        data: {
          'count': (groupResponse as List).length,
          'memberId': memberId,
        },
      );

      return groupResponse.map((json) => GroupModel.fromJson(json)).toList();
    } catch (e) {
      Logger.error(
        'Failed to fetch groups for member',
        tag: 'GroupDataSource',
        error: e,
      );
      throw ServerException('Failed to fetch groups by member: ${e.toString()}');
    }
  }

  @override
  Future<GroupModel> createGroup(GroupModel group) async {
    try {
      final response = await supabaseClient
          .from('group')
          .insert(group.toJson())
          .select()
          .single();

      return GroupModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to create group: ${e.toString()}');
    }
  }

  @override
  Future<GroupModel> updateGroup(GroupModel group) async {
    try {
      final response = await supabaseClient
          .from('group')
          .update(group.toJson())
          .eq('id', group.id)
          .select()
          .single();

      return GroupModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to update group: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    try {
      await supabaseClient.from('group').delete().eq('id', groupId);
    } catch (e) {
      throw ServerException('Failed to delete group: ${e.toString()}');
    }
  }

  @override
  Future<void> joinGroup(String groupId, String userId) async {
    try {
      await supabaseClient.from('group_member').insert({
        'group_id': groupId,
        'user_id': userId,
        'joined_at': DateTime.now().toIso8601String(),
      });

      // Increment members count
      await supabaseClient.rpc('increment_group_members', params: {'group_id': groupId});
    } catch (e) {
      throw ServerException('Failed to join group: ${e.toString()}');
    }
  }

  @override
  Future<void> leaveGroup(String groupId, String userId) async {
    try {
      await supabaseClient
          .from('group_member')
          .delete()
          .eq('group_id', groupId)
          .eq('user_id', userId);

      // Decrement members count
      await supabaseClient.rpc('decrement_group_members', params: {'group_id': groupId});
    } catch (e) {
      throw ServerException('Failed to leave group: ${e.toString()}');
    }
  }

  @override
  Future<void> incrementViewCount(String groupId) async {
    try {
      // Get current view_count and increment
      final response = await supabaseClient
          .from('group')
          .select('view_count')
          .eq('id', groupId)
          .single();

      final currentCount = (response['view_count'] as num?)?.toInt() ?? 0;

      await supabaseClient
          .from('group')
          .update({'view_count': currentCount + 1})
          .eq('id', groupId);

      Logger.info(
        'Incremented view count for group $groupId: ${currentCount + 1}',
        tag: 'GroupDataSource',
      );
    } catch (e) {
      // Don't throw - view count increment failure shouldn't break the app
      Logger.warning(
        'Failed to increment view count for group $groupId: $e',
        tag: 'GroupDataSource',
      );
    }
  }
}
