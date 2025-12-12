import 'package:equatable/equatable.dart';
import 'package:fitkle/features/chat/data/models/chat_room_model.dart';
import 'package:fitkle/features/chat/data/models/chat_message_model.dart';

/// Chat room with additional details for UI display
class ChatRoomWithDetailsModel extends Equatable {
  final ChatRoomModel room;
  final ChatMessageModel? lastMessage;
  final int unreadCount;
  final String? otherMemberName;
  final String? otherMemberId;

  const ChatRoomWithDetailsModel({
    required this.room,
    this.lastMessage,
    this.unreadCount = 0,
    this.otherMemberName,
    this.otherMemberId,
  });

  @override
  List<Object?> get props => [
        room,
        lastMessage,
        unreadCount,
        otherMemberName,
        otherMemberId,
      ];

  ChatRoomWithDetailsModel copyWith({
    ChatRoomModel? room,
    ChatMessageModel? lastMessage,
    int? unreadCount,
    String? otherMemberName,
    String? otherMemberId,
  }) {
    return ChatRoomWithDetailsModel(
      room: room ?? this.room,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      otherMemberName: otherMemberName ?? this.otherMemberName,
      otherMemberId: otherMemberId ?? this.otherMemberId,
    );
  }
}
