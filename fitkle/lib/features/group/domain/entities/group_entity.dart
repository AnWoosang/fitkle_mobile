import 'package:equatable/equatable.dart';

/// Group entity matching Supabase 'groups' table
class GroupEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String groupCategoryId; // UUID reference to group_categories
  final int totalMembers;
  final String thumbnailImageUrl;
  final String hostName;
  final String hostId;
  final int eventCount;
  final List<String> tags;
  final String location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int viewCount;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.groupCategoryId,
    required this.totalMembers,
    required this.thumbnailImageUrl,
    required this.hostName,
    required this.hostId,
    required this.eventCount,
    required this.tags,
    required this.location,
    this.createdAt,
    this.updatedAt,
    this.viewCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        groupCategoryId,
        totalMembers,
        thumbnailImageUrl,
        hostName,
        hostId,
        eventCount,
        tags,
        location,
        createdAt,
        updatedAt,
        viewCount,
      ];
}
