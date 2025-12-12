import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/chat/domain/repositories/chat_repository.dart';
import 'package:fitkle/features/chat/domain/entities/chat_room_entity.dart';
import 'package:fitkle/features/chat/domain/entities/chat_message_entity.dart';
import 'package:fitkle/features/chat/data/models/chat_room_with_details_model.dart';
import 'package:fitkle/features/chat/data/datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ChatRoomWithDetailsModel>>> getChatRooms(
    String userId,
  ) async {
    try {
      final rooms = await _remoteDataSource.getChatRooms(userId);
      return Right(rooms);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatRoomEntity>> getChatRoom(String roomId) async {
    try {
      final room = await _remoteDataSource.getChatRoom(roomId);
      if (room == null) {
        return Left(ServerFailure('Chat room not found'));
      }
      return Right(room.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatRoomEntity>> getOrCreateDirectChatRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    try {
      final room = await _remoteDataSource.getOrCreateDirectChatRoom(
        currentUserId,
        otherUserId,
      );
      return Right(room.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages(
    String roomId, {
    int limit = 50,
  }) async {
    try {
      final messages = await _remoteDataSource.getMessages(roomId, limit: limit);
      return Right(messages.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String roomId,
    required String senderId,
    required String senderName,
    required String message,
    String messageType = 'text',
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final sentMessage = await _remoteDataSource.sendMessage(
        roomId: roomId,
        senderId: senderId,
        senderName: senderName,
        message: message,
        messageType: messageType,
        metadata: metadata,
      );
      return Right(sentMessage.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, ChatMessageEntity>> subscribeToMessages(
    String roomId,
  ) {
    try {
      return _remoteDataSource
          .subscribeToMessages(roomId)
          .map((message) => Right<Failure, ChatMessageEntity>(message.toEntity()))
          .handleError((error) {
        return Left<Failure, ChatMessageEntity>(ServerFailure(error.toString()));
      });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Stream<Either<Failure, List<ChatRoomWithDetailsModel>>> subscribeToChatRooms(
    String userId,
  ) {
    try {
      return _remoteDataSource
          .subscribeToChatRooms(userId)
          .map((rooms) => Right<Failure, List<ChatRoomWithDetailsModel>>(rooms))
          .handleError((error) {
        return Left<Failure, List<ChatRoomWithDetailsModel>>(
          ServerFailure(error.toString()),
        );
      });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> updateLastRead(
    String roomId,
    String userId,
  ) async {
    try {
      await _remoteDataSource.updateLastRead(roomId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveChatRoom(
    String roomId,
    String userId,
  ) async {
    try {
      await _remoteDataSource.leaveChatRoom(roomId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount(
    String roomId,
    String userId,
  ) async {
    try {
      final count = await _remoteDataSource.getUnreadCount(roomId, userId);
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
