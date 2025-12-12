import 'package:fitkle/features/chat/domain/entities/chat_message_entity.dart';

/// Chat message model for Supabase JSON serialization
class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.roomId,
    required super.senderId,
    required super.senderName,
    required super.message,
    super.messageType = 'text',
    super.metadata,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from Supabase JSON
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      message: json['message'] as String,
      messageType: json['message_type'] as String? ?? 'text',
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert model to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'sender_name': senderName,
      'message': message,
      'message_type': messageType,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create model from entity
  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      roomId: entity.roomId,
      senderId: entity.senderId,
      senderName: entity.senderName,
      message: entity.message,
      messageType: entity.messageType,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert model to entity
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      roomId: roomId,
      senderId: senderId,
      senderName: senderName,
      message: message,
      messageType: messageType,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
