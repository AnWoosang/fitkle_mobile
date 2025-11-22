import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/event/domain/entities/event_category_entity.dart';
import 'package:fitkle/features/event/domain/repositories/event_category_repository.dart';

class EventCategoryService {
  final EventCategoryRepository _repository;

  EventCategoryService(this._repository);

  Future<Either<Failure, List<EventCategoryEntity>>> getCategories() async {
    return await _repository.getCategories();
  }

  Future<Either<Failure, EventCategoryEntity?>> getCategoryByCode(String code) async {
    return await _repository.getCategoryByCode(code);
  }

  Future<Either<Failure, EventCategoryEntity?>> getCategoryById(String id) async {
    return await _repository.getCategoryById(id);
  }
}
