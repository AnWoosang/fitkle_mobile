import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/event/domain/entities/event_category_entity.dart';

abstract class EventCategoryRepository {
  Future<Either<Failure, List<EventCategoryEntity>>> getCategories();
  Future<Either<Failure, EventCategoryEntity?>> getCategoryByCode(String code);
  Future<Either<Failure, EventCategoryEntity?>> getCategoryById(String id);
}
