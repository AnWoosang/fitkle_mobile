import 'package:equatable/equatable.dart';

/// Message entity matching Supabase 'message' table
class MessageEntity extends Equatable {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String message;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MessageEntity({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.message,
    this.isRead = false,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        fromUserId,
        toUserId,
        message,
        isRead,
        createdAt,
        updatedAt,
      ];
}
