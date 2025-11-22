import 'package:equatable/equatable.dart';

/// Group member entity matching Supabase 'group_member' table
class GroupMemberEntity extends Equatable {
  final String id;
  final String groupId;
  final String userId;
  final String role; // 'admin', 'moderator', 'member'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GroupMemberEntity({
    required this.id,
    required this.groupId,
    required this.userId,
    this.role = 'member',
    this.createdAt,
    this.updatedAt,
  });

  bool get isAdmin => role == 'admin';
  bool get isModerator => role == 'moderator';
  bool get isMember => role == 'member';

  @override
  List<Object?> get props => [
        id,
        groupId,
        userId,
        role,
        createdAt,
        updatedAt,
      ];
}
