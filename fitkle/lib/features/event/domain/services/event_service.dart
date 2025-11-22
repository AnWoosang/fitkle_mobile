import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';
import 'package:fitkle/features/event/domain/repositories/event_repository.dart';

class EventService {
  final EventRepository _repository;

  EventService(this._repository);

  Future<Either<Failure, List<EventEntity>>> getEvents({
    String? category,
    String? searchQuery,
    bool? isGroupEvent,
  }) async {
    return await _repository.getEvents(
      category: category,
      searchQuery: searchQuery,
      isGroupEvent: isGroupEvent,
    );
  }

  Future<Either<Failure, EventEntity>> getEventById(String eventId) async {
    return await _repository.getEventById(eventId);
  }

  Future<Either<Failure, List<EventEntity>>> getUpcomingEvents() async {
    return await _repository.getUpcomingEvents();
  }

  Future<Either<Failure, List<EventEntity>>> getEventsByHost(String hostId) async {
    return await _repository.getEventsByHost(hostId);
  }

  Future<Either<Failure, EventEntity>> createEvent(EventEntity event) async {
    return await _repository.createEvent(event);
  }

  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event) async {
    return await _repository.updateEvent(event);
  }

  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    return await _repository.deleteEvent(eventId);
  }

  Future<Either<Failure, void>> joinEvent(String eventId, String userId) async {
    return await _repository.joinEvent(eventId, userId);
  }

  Future<Either<Failure, void>> leaveEvent(String eventId, String userId) async {
    return await _repository.leaveEvent(eventId, userId);
  }
}
