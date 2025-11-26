import 'package:fitkle/features/event/domain/entities/event_entity.dart';
import 'package:fitkle/features/event/domain/entities/event_type.dart';

class EventModel {
  final String id;
  final String title;
  final DateTime datetime;
  final String address;
  final String? detailAddress;
  final int attendees;
  final int maxAttendees;
  final String thumbnailImageUrl;
  final String eventCategoryId;
  final EventType eventType;
  final String? groupId;
  final String? groupName;
  final String description;
  final String hostName;
  final String hostId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? latitude;
  final double? longitude;
  final List<String> tags;
  final bool isGroupMembersOnly;
  final int viewCount;

  const EventModel({
    required this.id,
    required this.title,
    required this.datetime,
    required this.address,
    this.detailAddress,
    required this.attendees,
    required this.maxAttendees,
    required this.thumbnailImageUrl,
    required this.eventCategoryId,
    required this.eventType,
    this.groupId,
    this.groupName,
    required this.description,
    required this.hostName,
    required this.hostId,
    required this.createdAt,
    required this.updatedAt,
    this.latitude,
    this.longitude,
    this.tags = const [],
    this.isGroupMembersOnly = false,
    this.viewCount = 0,
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
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
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
      'view_count': viewCount,
    };
  }

  /// Convert Model to Entity (Data Layer → Domain Layer)
  EventEntity toEntity() {
    return EventEntity(
      id: id,
      title: title,
      datetime: datetime,
      address: address,
      detailAddress: detailAddress,
      attendees: attendees,
      maxAttendees: maxAttendees,
      thumbnailImageUrl: thumbnailImageUrl,
      eventCategoryId: eventCategoryId,
      eventType: eventType,
      groupId: groupId,
      groupName: groupName,
      description: description,
      hostName: hostName,
      hostId: hostId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      latitude: latitude,
      longitude: longitude,
      tags: tags,
      isGroupMembersOnly: isGroupMembersOnly,
      viewCount: viewCount,
    );
  }

  /// Create Model from Entity (Domain Layer → Data Layer)
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
      viewCount: entity.viewCount,
    );
  }
}
