import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';

abstract class EventRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents({
    String? category,
    String? searchQuery,
    bool? isGroupEvent,
    int limit = 30,
    int offset = 0,
  });

  Future<Either<Failure, EventEntity>> getEventById(String eventId);

  Future<Either<Failure, List<EventEntity>>> getUpcomingEventsByMember(String memberId);

  Future<Either<Failure, List<EventEntity>>> getEventsByHost(String hostId);

  Future<Either<Failure, EventEntity>> createEvent(EventEntity event);

  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event);

  Future<Either<Failure, void>> deleteEvent(String eventId);

  Future<Either<Failure, void>> joinEvent(String eventId, String userId);

  Future<Either<Failure, void>> leaveEvent(String eventId, String userId);

  Future<void> incrementViewCount(String eventId);
}
