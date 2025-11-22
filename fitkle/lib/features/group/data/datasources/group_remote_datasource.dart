import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/utils/logger.dart';
import 'package:fitkle/features/group/data/models/group_model.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupModel>> getGroups({String? category, String? searchQuery});
  Future<GroupModel> getGroupById(String groupId);
  Future<List<GroupModel>> getGroupsByHost(String hostId);
  Future<GroupModel> createGroup(GroupModel group);
  Future<GroupModel> updateGroup(GroupModel group);
  Future<void> deleteGroup(String groupId);
  Future<void> joinGroup(String groupId, String userId);
  Future<void> leaveGroup(String groupId, String userId);
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final SupabaseClient supabaseClient;

  GroupRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<GroupModel>> getGroups({String? category, String? searchQuery}) async {
    try {
      // Build query parameters for logging
      final params = <String, dynamic>{
        'table': 'group',
        'select': '*',
        if (category != null && category != 'all') 'category': category,
        if (searchQuery != null && searchQuery.isNotEmpty) 'name.ilike': '%$searchQuery%',
        'order': 'created_at.desc',
      };

      Logger.request(
        'GET',
        'Supabase REST API /rest/v1/group',
        data: params,
      );

      var query = supabaseClient.from('group').select();

      if (category != null && category != 'all') {
        query = query.eq('category', category);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.ilike('name', '%$searchQuery%');
      }

      final response = await query.order('created_at', ascending: false);

      Logger.response(
        200,
        'Supabase REST API /rest/v1/group',
        data: {
          'count': (response as List).length,
          'sample': response.take(2).toList(),
        },
      );

      Logger.debug(
        'Raw response sample: ${response.take(1).toList()}',
        tag: 'GroupDataSource',
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
}
