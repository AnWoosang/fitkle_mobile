import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/tag/domain/entities/tag_entity.dart';

abstract class TagRepository {
  Future<Either<Failure, List<TagEntity>>> getTags();
  Future<Either<Failure, List<TagEntity>>> getTagsByGroup(String categoryGroup);
  Future<Either<Failure, List<TagEntity>>> getTagsByGroups(List<String> categoryGroups);
  Future<Either<Failure, TagEntity?>> getTagByName(String name);
  Future<Either<Failure, TagEntity?>> getTagById(String id);
  Future<Either<Failure, List<TagEntity>>> getTagsByIds(List<String> ids);
  Future<Either<Failure, List<TagEntity>>> getTagsByNames(List<String> names);
  Future<Either<Failure, List<String>>> getCategoryGroups();
}
