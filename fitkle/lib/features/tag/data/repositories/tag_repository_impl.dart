import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/core/network/network_info.dart';
import 'package:fitkle/features/tag/domain/entities/tag_entity.dart';
import 'package:fitkle/features/tag/domain/repositories/tag_repository.dart';
import 'package:fitkle/features/tag/data/datasources/tag_remote_datasource.dart';

class TagRepositoryImpl implements TagRepository {
  final TagRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  // 캐시
  List<TagEntity>? _cachedTags;

  TagRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TagEntity>>> getTags() async {
    if (await networkInfo.isConnected) {
      try {
        // 캐시가 있으면 반환
        if (_cachedTags != null) {
          return Right(_cachedTags!);
        }

        final tags = await remoteDataSource.getTags();
        _cachedTags = tags;
        return Right(tags);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getTagsByGroup(String categoryGroup) async {
    final result = await getTags();
    return result.fold(
      (failure) => Left(failure),
      (tags) => Right(tags.where((tag) => tag.categoryGroup == categoryGroup).toList()),
    );
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getTagsByGroups(List<String> categoryGroups) async {
    final result = await getTags();
    return result.fold(
      (failure) => Left(failure),
      (tags) => Right(tags.where((tag) => categoryGroups.contains(tag.categoryGroup)).toList()),
    );
  }

  @override
  Future<Either<Failure, TagEntity?>> getTagByName(String name) async {
    final result = await getTags();
    return result.fold(
      (failure) => Left(failure),
      (tags) {
        try {
          final tag = tags.firstWhere((tag) => tag.name == name);
          return Right(tag);
        } catch (e) {
          return const Right(null);
        }
      },
    );
  }

  @override
  Future<Either<Failure, TagEntity?>> getTagById(String id) async {
    final result = await getTags();
    return result.fold(
      (failure) => Left(failure),
      (tags) {
        try {
          final tag = tags.firstWhere((tag) => tag.id == id);
          return Right(tag);
        } catch (e) {
          return const Right(null);
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getTagsByIds(List<String> ids) async {
    final result = await getTags();
    return result.fold(
      (failure) => Left(failure),
      (tags) => Right(tags.where((tag) => ids.contains(tag.id)).toList()),
    );
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getTagsByNames(List<String> names) async {
    final result = await getTags();
    return result.fold(
      (failure) => Left(failure),
      (tags) => Right(tags.where((tag) => names.contains(tag.name)).toList()),
    );
  }

  @override
  Future<Either<Failure, List<String>>> getCategoryGroups() async {
    final result = await getTags();
    return result.fold(
      (failure) => Left(failure),
      (tags) {
        final groups = tags.map((tag) => tag.categoryGroup).toSet().toList();
        groups.sort();
        return Right(groups);
      },
    );
  }

  void clearCache() {
    _cachedTags = null;
  }
}
