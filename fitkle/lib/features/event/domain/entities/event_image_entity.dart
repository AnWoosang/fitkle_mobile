import 'package:equatable/equatable.dart';

/// Event image entity matching Supabase 'event_image' table
class EventImageEntity extends Equatable {
  final String id;
  final String eventId;
  final String imageUrl;
  final String? caption;
  final int displayOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EventImageEntity({
    required this.id,
    required this.eventId,
    required this.imageUrl,
    this.caption,
    this.displayOrder = 0,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        eventId,
        imageUrl,
        caption,
        displayOrder,
        createdAt,
        updatedAt,
      ];
}
