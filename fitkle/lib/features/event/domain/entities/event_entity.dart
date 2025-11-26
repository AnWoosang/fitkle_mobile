import 'package:equatable/equatable.dart';
import 'package:fitkle/features/event/domain/entities/event_type.dart';

/// Event entity matching Supabase 'event' table
class EventEntity extends Equatable {
  final String id;
  final String title;
  final DateTime datetime; // 이벤트 날짜 및 시간
  final String address; // 오프라인: 기본 주소, 온라인: 미팅 링크 (Zoom, Google Meet 등)
  final String? detailAddress; // 오프라인: 상세 주소 (동/호수 등)
  final int attendees;
  final int maxAttendees;
  final String thumbnailImageUrl;
  final String eventCategoryId; // UUID reference to event_categories
  final EventType eventType;
  final String? groupId;
  final String? groupName; // 그룹 이벤트인 경우 그룹 이름
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

  const EventEntity({
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

  bool get isFull => attendees >= maxAttendees;

  @override
  List<Object?> get props => [
        id,
        title,
        datetime,
        address,
        detailAddress,
        attendees,
        maxAttendees,
        thumbnailImageUrl,
        eventCategoryId,
        eventType,
        groupId,
        groupName,
        description,
        hostName,
        hostId,
        createdAt,
        updatedAt,
        latitude,
        longitude,
        tags,
        isGroupMembersOnly,
        viewCount,
      ];
}
