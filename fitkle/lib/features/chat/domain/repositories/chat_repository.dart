import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/chat/domain/entities/chat_room_entity.dart';
import 'package:fitkle/features/chat/domain/entities/chat_message_entity.dart';
import 'package:fitkle/features/chat/data/models/chat_room_with_details_model.dart';

abstract class ChatRepository {
  /// Get all chat rooms for the current user
  Future<Either<Failure, List<ChatRoomWithDetailsModel>>> getChatRooms(
    String userId,
  );

  /// Get a specific chat room by ID
  Future<Either<Failure, ChatRoomEntity>> getChatRoom(String roomId);

  /// Create or get direct chat room with another user
  Future<Either<Failure, ChatRoomEntity>> getOrCreateDirectChatRoom(
    String currentUserId,
    String otherUserId,
  );

  /// Get messages for a specific room
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages(
    String roomId, {
    int limit = 50,
  });

  /// Send a message to a room
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String roomId,
    required String senderId,
    required String senderName,
    required String message,
    String messageType = 'text',
    Map<String, dynamic>? metadata,
  });

  /// Subscribe to new messages in a room
  Stream<Either<Failure, ChatMessageEntity>> subscribeToMessages(String roomId);

  /// Subscribe to chat room updates
  Stream<Either<Failure, List<ChatRoomWithDetailsModel>>> subscribeToChatRooms(
    String userId,
  );

  /// Update last read timestamp
  Future<Either<Failure, void>> updateLastRead(String roomId, String userId);

  /// Leave a chat room
  Future<Either<Failure, void>> leaveChatRoom(String roomId, String userId);

  /// Get unread message count for a room
  Future<Either<Failure, int>> getUnreadCount(String roomId, String userId);
}
