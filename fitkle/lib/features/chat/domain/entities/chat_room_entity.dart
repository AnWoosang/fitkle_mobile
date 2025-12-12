import 'package:equatable/equatable.dart';

/// Chat room entity representing a conversation space
class ChatRoomEntity extends Equatable {
  final String id;
  final String type; // 'direct', 'group', 'event'
  final String? groupId;
  final String? eventId;
  final String? name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatRoomEntity({
    required this.id,
    required this.type,
    this.groupId,
    this.eventId,
    this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        groupId,
        eventId,
        name,
        createdAt,
        updatedAt,
      ];

  ChatRoomEntity copyWith({
    String? id,
    String? type,
    String? groupId,
    String? eventId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatRoomEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      groupId: groupId ?? this.groupId,
      eventId: eventId ?? this.eventId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
