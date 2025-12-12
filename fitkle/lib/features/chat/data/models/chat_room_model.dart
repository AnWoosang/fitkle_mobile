import 'package:fitkle/features/chat/domain/entities/chat_room_entity.dart';

/// Chat room model for Supabase JSON serialization
class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required super.id,
    required super.type,
    super.groupId,
    super.eventId,
    super.name,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from Supabase JSON
  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] as String,
      type: json['type'] as String,
      groupId: json['group_id'] as String?,
      eventId: json['event_id'] as String?,
      name: json['name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert model to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'group_id': groupId,
      'event_id': eventId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create model from entity
  factory ChatRoomModel.fromEntity(ChatRoomEntity entity) {
    return ChatRoomModel(
      id: entity.id,
      type: entity.type,
      groupId: entity.groupId,
      eventId: entity.eventId,
      name: entity.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert model to entity
  ChatRoomEntity toEntity() {
    return ChatRoomEntity(
      id: id,
      type: type,
      groupId: groupId,
      eventId: eventId,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
