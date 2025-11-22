import 'package:fitkle/features/event/domain/entities/event_entity.dart';
import 'package:fitkle/features/event/domain/entities/event_type.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    required super.datetime,
    required super.address,
    super.detailAddress,
    required super.attendees,
    required super.maxAttendees,
    required super.thumbnailImageUrl,
    required super.eventCategoryId,
    required super.eventType,
    super.groupId,
    super.groupName,
    required super.description,
    required super.hostName,
    required super.hostId,
    required super.createdAt,
    required super.updatedAt,
    super.latitude,
    super.longitude,
    super.tags = const [],
    super.isGroupMembersOnly = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Parse tags from JSONB
    List<String> parsedTags = [];
    if (json['tags'] != null) {
      if (json['tags'] is List) {
        parsedTags = List<String>.from(json['tags']);
      } else if (json['tags'] is String) {
        // Handle JSON string
        try {
          final decoded = json['tags'];
          if (decoded is List) {
            parsedTags = List<String>.from(decoded);
          }
        } catch (e) {
          parsedTags = [];
        }
      }
    }

    return EventModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      datetime: json['datetime'] != null ? DateTime.parse(json['datetime'] as String) : DateTime.now(),
      address: json['address'] as String? ?? 'TBD',
      detailAddress: json['detail_address'] as String?,
      attendees: (json['attendees'] as num?)?.toInt() ?? 0,
      maxAttendees: (json['max_attendees'] as num?)?.toInt() ?? 0,
      thumbnailImageUrl: json['thumbnail_image_url'] as String? ?? '',
      eventCategoryId: json['event_category_id'] as String? ?? '',
      eventType: EventType.fromString(json['type'] as String? ?? 'OFFLINE'),
      groupId: json['group_id'] as String?,
      groupName: json['group_name'] as String?,
      description: json['description'] as String? ?? '',
      hostName: json['host_name'] as String? ?? 'Unknown Host',
      hostId: json['host_member_id'] as String? ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : DateTime.now(),
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      tags: parsedTags,
      isGroupMembersOnly: json['is_group_members_only'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'datetime': datetime.toIso8601String(),
      'address': address,
      'detail_address': detailAddress,
      'attendees': attendees,
      'max_attendees': maxAttendees,
      'thumbnail_image_url': thumbnailImageUrl,
      'event_category_id': eventCategoryId,
      'type': eventType.value,
      'group_id': groupId,
      'group_name': groupName,
      'description': description,
      'host_name': hostName,
      'host_member_id': hostId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'tags': tags,
      'is_group_members_only': isGroupMembersOnly,
    };
  }

  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      id: entity.id,
      title: entity.title,
      datetime: entity.datetime,
      address: entity.address,
      detailAddress: entity.detailAddress,
      attendees: entity.attendees,
      maxAttendees: entity.maxAttendees,
      thumbnailImageUrl: entity.thumbnailImageUrl,
      eventCategoryId: entity.eventCategoryId,
      eventType: entity.eventType,
      groupId: entity.groupId,
      groupName: entity.groupName,
      description: entity.description,
      hostName: entity.hostName,
      hostId: entity.hostId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      latitude: entity.latitude,
      longitude: entity.longitude,
      tags: entity.tags,
      isGroupMembersOnly: entity.isGroupMembersOnly,
    );
  }
}
