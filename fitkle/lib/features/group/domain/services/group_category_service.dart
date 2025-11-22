import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/group/domain/entities/group_category_entity.dart';
import 'package:fitkle/features/group/domain/repositories/group_category_repository.dart';

class GroupCategoryService {
  final GroupCategoryRepository _repository;

  GroupCategoryService(this._repository);

  Future<Either<Failure, List<GroupCategoryEntity>>> getCategories() async {
    return await _repository.getCategories();
  }

  Future<Either<Failure, GroupCategoryEntity?>> getCategoryByCode(String code) async {
    return await _repository.getCategoryByCode(code);
  }

  Future<Either<Failure, GroupCategoryEntity?>> getCategoryById(String id) async {
    return await _repository.getCategoryById(id);
  }
}
