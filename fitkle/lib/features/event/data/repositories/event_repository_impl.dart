import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/core/network/network_info.dart';
import 'package:fitkle/core/utils/logger.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';
import 'package:fitkle/features/event/domain/repositories/event_repository.dart';
import 'package:fitkle/features/event/data/datasources/event_remote_datasource.dart';
import 'package:fitkle/features/event/data/models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EventRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents({
    String? category,
    String? searchQuery,
    bool? isGroupEvent,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Logger.info(
          'Fetching events (category: $category, search: $searchQuery, isGroupEvent: $isGroupEvent)',
          tag: 'EventRepository',
        );
        final events = await remoteDataSource.getEvents(
          category: category,
          searchQuery: searchQuery,
          isGroupEvent: isGroupEvent,
        );
        Logger.success(
          'Fetched ${events.length} events',
          tag: 'EventRepository',
        );
        return Right(events);
      } on ServerException catch (e) {
        Logger.error(
          'Server error while fetching events',
          tag: 'EventRepository',
          error: e,
        );
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        Logger.error(
          'Network error while fetching events',
          tag: 'EventRepository',
          error: e,
        );
        return Left(NetworkFailure(e.message));
      }
    } else {
      Logger.warning('No internet connection', tag: 'EventRepository');
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> getEventById(String eventId) async {
    if (await networkInfo.isConnected) {
      try {
        Logger.info('Fetching event: $eventId', tag: 'EventRepository');
        final event = await remoteDataSource.getEventById(eventId);
        Logger.success(
          'Fetched event: ${event.title}',
          tag: 'EventRepository',
        );
        return Right(event);
      } on NotFoundException catch (e) {
        Logger.warning(
          'Event not found: $eventId',
          tag: 'EventRepository',
        );
        return Left(NotFoundFailure(e.message));
      } on ServerException catch (e) {
        Logger.error(
          'Server error while fetching event: $eventId',
          tag: 'EventRepository',
          error: e,
        );
        return Left(ServerFailure(e.message));
      }
    } else {
      Logger.warning('No internet connection', tag: 'EventRepository');
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getUpcomingEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.getUpcomingEvents();
        return Right(events);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getEventsByHost(String hostId) async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.getEventsByHost(hostId);
        return Right(events);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> createEvent(EventEntity event) async {
    if (await networkInfo.isConnected) {
      try {
        final eventModel = EventModel.fromEntity(event);
        final createdEvent = await remoteDataSource.createEvent(eventModel);
        return Right(createdEvent);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event) async {
    if (await networkInfo.isConnected) {
      try {
        final eventModel = EventModel.fromEntity(event);
        final updatedEvent = await remoteDataSource.updateEvent(eventModel);
        return Right(updatedEvent);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteEvent(eventId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> joinEvent(String eventId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.joinEvent(eventId, userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveEvent(String eventId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.leaveEvent(eventId, userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
