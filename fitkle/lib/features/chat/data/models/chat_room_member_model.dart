import 'package:equatable/equatable.dart';

/// Chat room member model for Supabase JSON serialization
class ChatRoomMemberModel extends Equatable {
  final String roomId;
  final String memberId;
  final DateTime joinedAt;
  final DateTime? leftAt;
  final bool isActive;
  final DateTime? lastReadAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatRoomMemberModel({
    required this.roomId,
    required this.memberId,
    required this.joinedAt,
    this.leftAt,
    required this.isActive,
    this.lastReadAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create model from Supabase JSON
  factory ChatRoomMemberModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomMemberModel(
      roomId: json['room_id'] as String,
      memberId: json['member_id'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      leftAt: json['left_at'] != null
          ? DateTime.parse(json['left_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      lastReadAt: json['last_read_at'] != null
          ? DateTime.parse(json['last_read_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert model to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'member_id': memberId,
      'joined_at': joinedAt.toIso8601String(),
      'left_at': leftAt?.toIso8601String(),
      'is_active': isActive,
      'last_read_at': lastReadAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        roomId,
        memberId,
        joinedAt,
        leftAt,
        isActive,
        lastReadAt,
        createdAt,
        updatedAt,
      ];

  ChatRoomMemberModel copyWith({
    String? roomId,
    String? memberId,
    DateTime? joinedAt,
    DateTime? leftAt,
    bool? isActive,
    DateTime? lastReadAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatRoomMemberModel(
      roomId: roomId ?? this.roomId,
      memberId: memberId ?? this.memberId,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
      isActive: isActive ?? this.isActive,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
