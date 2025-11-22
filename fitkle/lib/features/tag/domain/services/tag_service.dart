import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/tag/domain/entities/tag_entity.dart';
import 'package:fitkle/features/tag/domain/repositories/tag_repository.dart';

class TagService {
  final TagRepository _repository;

  TagService(this._repository);

  Future<Either<Failure, List<TagEntity>>> getTags() async {
    return await _repository.getTags();
  }

  Future<Either<Failure, List<TagEntity>>> getTagsByGroup(String categoryGroup) async {
    return await _repository.getTagsByGroup(categoryGroup);
  }

  Future<Either<Failure, List<TagEntity>>> getTagsByGroups(List<String> categoryGroups) async {
    return await _repository.getTagsByGroups(categoryGroups);
  }

  Future<Either<Failure, TagEntity?>> getTagByName(String name) async {
    return await _repository.getTagByName(name);
  }

  Future<Either<Failure, TagEntity?>> getTagById(String id) async {
    return await _repository.getTagById(id);
  }

  Future<Either<Failure, List<TagEntity>>> getTagsByIds(List<String> ids) async {
    return await _repository.getTagsByIds(ids);
  }

  Future<Either<Failure, List<TagEntity>>> getTagsByNames(List<String> names) async {
    return await _repository.getTagsByNames(names);
  }

  Future<Either<Failure, List<String>>> getCategoryGroups() async {
    return await _repository.getCategoryGroups();
  }
}
