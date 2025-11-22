import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/core/network/network_info.dart';
import 'package:fitkle/features/group/domain/entities/group_category_entity.dart';
import 'package:fitkle/features/group/domain/repositories/group_category_repository.dart';
import 'package:fitkle/features/group/data/datasources/group_category_remote_datasource.dart';

class GroupCategoryRepositoryImpl implements GroupCategoryRepository {
  final GroupCategoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  // 캐시
  List<GroupCategoryEntity>? _cachedCategories;

  GroupCategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GroupCategoryEntity>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        // 캐시가 있으면 반환
        if (_cachedCategories != null) {
          return Right(_cachedCategories!);
        }

        final categories = await remoteDataSource.getCategories();
        _cachedCategories = categories;
        return Right(categories);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, GroupCategoryEntity?>> getCategoryByCode(String code) async {
    final result = await getCategories();
    return result.fold(
      (failure) => Left(failure),
      (categories) {
        try {
          final category = categories.firstWhere((cat) => cat.code == code);
          return Right(category);
        } catch (e) {
          return const Right(null);
        }
      },
    );
  }

  @override
  Future<Either<Failure, GroupCategoryEntity?>> getCategoryById(String id) async {
    final result = await getCategories();
    return result.fold(
      (failure) => Left(failure),
      (categories) {
        try {
          final category = categories.firstWhere((cat) => cat.id == id);
          return Right(category);
        } catch (e) {
          return const Right(null);
        }
      },
    );
  }

  void clearCache() {
    _cachedCategories = null;
  }
}
