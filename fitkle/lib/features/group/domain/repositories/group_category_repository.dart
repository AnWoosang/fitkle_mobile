import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/group/domain/entities/group_category_entity.dart';

abstract class GroupCategoryRepository {
  Future<Either<Failure, List<GroupCategoryEntity>>> getCategories();
  Future<Either<Failure, GroupCategoryEntity?>> getCategoryByCode(String code);
  Future<Either<Failure, GroupCategoryEntity?>> getCategoryById(String id);
}
