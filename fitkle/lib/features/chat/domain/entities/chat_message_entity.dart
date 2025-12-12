import 'package:equatable/equatable.dart';

/// Chat message entity representing a single message
class ChatMessageEntity extends Equatable {
  final String id;
  final String roomId;
  final String senderId;
  final String senderName;
  final String message;
  final String messageType; // 'text', 'image', 'file'
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatMessageEntity({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.message,
    this.messageType = 'text',
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        roomId,
        senderId,
        senderName,
        message,
        messageType,
        metadata,
        createdAt,
        updatedAt,
      ];

  ChatMessageEntity copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? senderName,
    String? message,
    String? messageType,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
