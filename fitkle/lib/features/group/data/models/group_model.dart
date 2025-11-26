import 'package:fitkle/features/group/domain/entities/group_entity.dart';

class GroupModel {
  final String id;
  final String name;
  final String description;
  final String groupCategoryId;
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

  const GroupModel({
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

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    // Parse tags (TEXT[] array from PostgreSQL)
    List<String> parsedTags = [];
    if (json['tags'] != null) {
      if (json['tags'] is List) {
        parsedTags = List<String>.from(json['tags']);
      }
    }

    return GroupModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      groupCategoryId: json['group_category_id'] as String? ?? '',
      totalMembers: (json['total_members'] as num?)?.toInt() ?? 0,
      thumbnailImageUrl: json['thumbnail_image_url'] as String? ?? '',
      hostName: json['host_name'] as String? ?? '',
      hostId: json['host_id'] as String? ?? '',
      eventCount: (json['event_count'] as num?)?.toInt() ?? 0,
      tags: parsedTags,
      location: json['location'] as String? ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'group_category_id': groupCategoryId,
      'total_members': totalMembers,
      'thumbnail_image_url': thumbnailImageUrl,
      'host_name': hostName,
      'host_id': hostId,
      'event_count': eventCount,
      'tags': tags,
      'location': location,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'view_count': viewCount,
    };
  }

  /// Convert Model to Entity (Data Layer → Domain Layer)
  GroupEntity toEntity() {
    return GroupEntity(
      id: id,
      name: name,
      description: description,
      groupCategoryId: groupCategoryId,
      totalMembers: totalMembers,
      thumbnailImageUrl: thumbnailImageUrl,
      hostName: hostName,
      hostId: hostId,
      eventCount: eventCount,
      tags: tags,
      location: location,
      createdAt: createdAt,
      updatedAt: updatedAt,
      viewCount: viewCount,
    );
  }

  /// Create Model from Entity (Domain Layer → Data Layer)
  factory GroupModel.fromEntity(GroupEntity entity) {
    return GroupModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      groupCategoryId: entity.groupCategoryId,
      totalMembers: entity.totalMembers,
      thumbnailImageUrl: entity.thumbnailImageUrl,
      hostName: entity.hostName,
      hostId: entity.hostId,
      eventCount: entity.eventCount,
      tags: entity.tags,
      location: entity.location,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      viewCount: entity.viewCount,
    );
  }
}
