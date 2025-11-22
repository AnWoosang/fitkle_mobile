import 'package:equatable/equatable.dart';

/// Event participant entity matching Supabase 'event_participant' table
class EventParticipantEntity extends Equatable {
  final String id;
  final String eventId;
  final String userId;
  final String status; // 'confirmed', 'cancelled', 'pending'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EventParticipantEntity({
    required this.id,
    required this.eventId,
    required this.userId,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  bool get isConfirmed => status == 'confirmed';
  bool get isPending => status == 'pending';
  bool get isCancelled => status == 'cancelled';

  @override
  List<Object?> get props => [
        id,
        eventId,
        userId,
        status,
        createdAt,
        updatedAt,
      ];
}
