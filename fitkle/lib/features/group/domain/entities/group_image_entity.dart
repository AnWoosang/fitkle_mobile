import 'package:equatable/equatable.dart';

/// Group image entity matching Supabase 'group_image' table
class GroupImageEntity extends Equatable {
  final String id;
  final String groupId;
  final String imageUrl;
  final String? caption;
  final int displayOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GroupImageEntity({
    required this.id,
    required this.groupId,
    required this.imageUrl,
    this.caption,
    this.displayOrder = 0,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        groupId,
        imageUrl,
        caption,
        displayOrder,
        createdAt,
        updatedAt,
      ];
}
