import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/features/chat/data/models/chat_room_model.dart';
import 'package:fitkle/features/chat/data/models/chat_message_model.dart';
import 'package:fitkle/features/chat/data/models/chat_room_with_details_model.dart';

abstract class ChatRemoteDataSource {
  /// Get all chat rooms for the current user
  Future<List<ChatRoomWithDetailsModel>> getChatRooms(String userId);

  /// Get a specific chat room by ID
  Future<ChatRoomModel?> getChatRoom(String roomId);

  /// Create or get direct chat room with another user
  Future<ChatRoomModel> getOrCreateDirectChatRoom(
    String currentUserId,
    String otherUserId,
  );

  /// Get messages for a specific room
  Future<List<ChatMessageModel>> getMessages(String roomId, {int limit = 50});

  /// Send a message to a room
  Future<ChatMessageModel> sendMessage({
    required String roomId,
    required String senderId,
    required String senderName,
    required String message,
    String messageType = 'text',
    Map<String, dynamic>? metadata,
  });

  /// Subscribe to new messages in a room
  Stream<ChatMessageModel> subscribeToMessages(String roomId);

  /// Subscribe to chat room updates
  Stream<List<ChatRoomWithDetailsModel>> subscribeToChatRooms(String userId);

  /// Update last read timestamp
  Future<void> updateLastRead(String roomId, String userId);

  /// Leave a chat room
  Future<void> leaveChatRoom(String roomId, String userId);

  /// Get unread message count for a room
  Future<int> getUnreadCount(String roomId, String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient _supabase;

  ChatRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<ChatRoomWithDetailsModel>> getChatRooms(String userId) async {
    try {
      // Get all room IDs where user is an active member
      final memberResponse = await _supabase
          .from('chat_room_members')
          .select('room_id, last_read_at')
          .eq('member_id', userId)
          .eq('is_active', true);

      final members = (memberResponse as List)
          .map((json) => json as Map<String, dynamic>)
          .toList();

      if (members.isEmpty) {
        return [];
      }

      final roomIds = members.map((m) => m['room_id'] as String).toList();

      // Get room details
      final roomsResponse = await _supabase
          .from('chat_rooms')
          .select()
          .inFilter('id', roomIds)
          .order('updated_at', ascending: false);

      final rooms = (roomsResponse as List)
          .map((json) => ChatRoomModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Get last message and unread count for each room
      final roomsWithDetails = <ChatRoomWithDetailsModel>[];

      for (final room in rooms) {
        final memberData = members.firstWhere((m) => m['room_id'] == room.id);
        final lastReadAt = memberData['last_read_at'] != null
            ? DateTime.parse(memberData['last_read_at'] as String)
            : null;

        // Get last message
        final lastMessageResponse = await _supabase
            .from('chat_messages')
            .select()
            .eq('room_id', room.id)
            .eq('is_deleted', false)
            .order('created_at', ascending: false)
            .limit(1);

        ChatMessageModel? lastMessage;
        if ((lastMessageResponse as List).isNotEmpty) {
          lastMessage = ChatMessageModel.fromJson(
            lastMessageResponse.first as Map<String, dynamic>,
          );
        }

        // Get unread count
        int unreadCount = 0;
        if (lastReadAt != null) {
          final unreadResponse = await _supabase
              .from('chat_messages')
              .select()
              .eq('room_id', room.id)
              .eq('is_deleted', false)
              .neq('sender_id', userId)
              .gt('created_at', lastReadAt.toIso8601String());

          unreadCount = (unreadResponse as List).length;
        }

        // For direct chats, get other member's info
        String? otherMemberName;
        String? otherMemberId;
        if (room.type == 'direct') {
          final otherMemberResponse = await _supabase
              .from('chat_room_members')
              .select('member_id')
              .eq('room_id', room.id)
              .neq('member_id', userId)
              .eq('is_active', true)
              .limit(1);

          if ((otherMemberResponse as List).isNotEmpty) {
            otherMemberId =
                otherMemberResponse.first['member_id'] as String;

            final memberInfoResponse = await _supabase
                .from('member')
                .select('nickname')
                .eq('id', otherMemberId)
                .single();

            otherMemberName = memberInfoResponse['nickname'] as String?;
          }
        }

        roomsWithDetails.add(ChatRoomWithDetailsModel(
          room: room,
          lastMessage: lastMessage,
          unreadCount: unreadCount,
          otherMemberName: otherMemberName,
          otherMemberId: otherMemberId,
        ));
      }

      return roomsWithDetails;
    } catch (e) {
      throw Exception('Failed to get chat rooms: $e');
    }
  }

  @override
  Future<ChatRoomModel?> getChatRoom(String roomId) async {
    try {
      final response = await _supabase
          .from('chat_rooms')
          .select()
          .eq('id', roomId)
          .single();

      return ChatRoomModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ChatRoomModel> getOrCreateDirectChatRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    try {
      // Find existing direct chat room between these two users
      final currentUserRooms = await _supabase
          .from('chat_room_members')
          .select('room_id')
          .eq('member_id', currentUserId)
          .eq('is_active', true);

      final currentUserRoomIds = (currentUserRooms as List)
          .map((m) => m['room_id'] as String)
          .toList();

      if (currentUserRoomIds.isNotEmpty) {
        final otherUserRooms = await _supabase
            .from('chat_room_members')
            .select('room_id')
            .eq('member_id', otherUserId)
            .eq('is_active', true)
            .inFilter('room_id', currentUserRoomIds);

        if ((otherUserRooms as List).isNotEmpty) {
          final commonRoomId = otherUserRooms.first['room_id'] as String;

          // Verify it's a direct chat room
          final roomResponse = await _supabase
              .from('chat_rooms')
              .select()
              .eq('id', commonRoomId)
              .eq('type', 'direct')
              .single();

          return ChatRoomModel.fromJson(roomResponse as Map<String, dynamic>);
        }
      }

      // Create new direct chat room
      final now = DateTime.now().toIso8601String();
      final roomResponse = await _supabase
          .from('chat_rooms')
          .insert({
            'type': 'direct',
            'created_at': now,
            'updated_at': now,
          })
          .select()
          .single();

      final newRoom =
          ChatRoomModel.fromJson(roomResponse as Map<String, dynamic>);

      // Add both members to the room
      await _supabase.from('chat_room_members').insert([
        {
          'room_id': newRoom.id,
          'member_id': currentUserId,
          'joined_at': now,
          'is_active': true,
          'created_at': now,
          'updated_at': now,
        },
        {
          'room_id': newRoom.id,
          'member_id': otherUserId,
          'joined_at': now,
          'is_active': true,
          'created_at': now,
          'updated_at': now,
        },
      ]);

      return newRoom;
    } catch (e) {
      throw Exception('Failed to get or create direct chat room: $e');
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessages(
    String roomId, {
    int limit = 50,
  }) async {
    try {
      final response = await _supabase
          .from('chat_messages')
          .select()
          .eq('room_id', roomId)
          .eq('is_deleted', false)
          .order('created_at', ascending: false)
          .limit(limit);

      final messages = (response as List)
          .map((json) => ChatMessageModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return messages.reversed.toList();
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String roomId,
    required String senderId,
    required String senderName,
    required String message,
    String messageType = 'text',
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('chat_messages')
          .insert({
            'room_id': roomId,
            'sender_id': senderId,
            'sender_name': senderName,
            'message': message,
            'message_type': messageType,
            'metadata': metadata,
            'is_deleted': false,
            'created_at': now,
            'updated_at': now,
          })
          .select()
          .single();

      // Update room's updated_at timestamp
      await _supabase
          .from('chat_rooms')
          .update({'updated_at': now}).eq('id', roomId);

      return ChatMessageModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Stream<ChatMessageModel> subscribeToMessages(String roomId) {
    return _supabase
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) {
          final filtered = data.where((item) =>
            item['room_id'] == roomId &&
            item['is_deleted'] == false
          ).toList();
          return ChatMessageModel.fromJson(filtered.last);
        });
  }

  @override
  Stream<List<ChatRoomWithDetailsModel>> subscribeToChatRooms(
    String userId,
  ) {
    // Note: This is a simplified implementation
    // For production, you might want to use a more sophisticated approach
    return _supabase
        .from('chat_rooms')
        .stream(primaryKey: ['id'])
        .order('updated_at', ascending: false)
        .asyncMap((rooms) async {
          // Filter rooms where user is a member
          final memberResponse = await _supabase
              .from('chat_room_members')
              .select('room_id')
              .eq('member_id', userId)
              .eq('is_active', true);

          final userRoomIds = (memberResponse as List)
              .map((m) => m['room_id'] as String)
              .toSet();

          final filteredRooms = rooms
              .where((room) => userRoomIds.contains(room['id']))
              .map((json) => ChatRoomModel.fromJson(json))
              .toList();

          // Get details for each room
          final roomsWithDetails = <ChatRoomWithDetailsModel>[];
          for (final room in filteredRooms) {
            // Simplified - in production, get last message and unread count
            roomsWithDetails.add(ChatRoomWithDetailsModel(room: room));
          }

          return roomsWithDetails;
        });
  }

  @override
  Future<void> updateLastRead(String roomId, String userId) async {
    try {
      final now = DateTime.now().toIso8601String();

      await _supabase
          .from('chat_room_members')
          .update({
            'last_read_at': now,
            'updated_at': now,
          })
          .eq('room_id', roomId)
          .eq('member_id', userId);
    } catch (e) {
      throw Exception('Failed to update last read: $e');
    }
  }

  @override
  Future<void> leaveChatRoom(String roomId, String userId) async {
    try {
      final now = DateTime.now().toIso8601String();

      await _supabase
          .from('chat_room_members')
          .update({
            'is_active': false,
            'left_at': now,
            'updated_at': now,
          })
          .eq('room_id', roomId)
          .eq('member_id', userId);
    } catch (e) {
      throw Exception('Failed to leave chat room: $e');
    }
  }

  @override
  Future<int> getUnreadCount(String roomId, String userId) async {
    try {
      final memberResponse = await _supabase
          .from('chat_room_members')
          .select('last_read_at')
          .eq('room_id', roomId)
          .eq('member_id', userId)
          .single();

      final lastReadAt = memberResponse['last_read_at'] as String?;

      if (lastReadAt == null) {
        return 0;
      }

      final unreadResponse = await _supabase
          .from('chat_messages')
          .select()
          .eq('room_id', roomId)
          .eq('is_deleted', false)
          .neq('sender_id', userId)
          .gt('created_at', lastReadAt);

      return (unreadResponse as List).length;
    } catch (e) {
      return 0;
    }
  }
}
