import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/core/network/network_info.dart';
import 'package:fitkle/core/utils/logger.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';
import 'package:fitkle/features/group/domain/repositories/group_repository.dart';
import 'package:fitkle/features/group/data/datasources/group_remote_datasource.dart';
import 'package:fitkle/features/group/data/models/group_model.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GroupRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups({
    String? category,
    String? searchQuery,
    int limit = 30,
    int offset = 0,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Logger.info(
          'Fetching groups (category: $category, search: $searchQuery, limit: $limit, offset: $offset)',
          tag: 'GroupRepository',
        );
        final groupModels = await remoteDataSource.getGroups(
          category: category,
          searchQuery: searchQuery,
          limit: limit,
          offset: offset,
        );
        final groups = groupModels.map((model) => model.toEntity()).toList();
        Logger.success(
          'Fetched ${groups.length} groups',
          tag: 'GroupRepository',
        );
        return Right(groups);
      } on ServerException catch (e) {
        Logger.error(
          'Server error while fetching groups',
          tag: 'GroupRepository',
          error: e,
        );
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        Logger.error(
          'Network error while fetching groups',
          tag: 'GroupRepository',
          error: e,
        );
        return Left(NetworkFailure(e.message));
      }
    } else {
      Logger.warning('No internet connection', tag: 'GroupRepository');
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> getGroupById(String groupId) async {
    if (await networkInfo.isConnected) {
      try {
        Logger.info('Fetching group: $groupId', tag: 'GroupRepository');
        final groupModel = await remoteDataSource.getGroupById(groupId);
        Logger.success(
          'Fetched group: ${groupModel.name}',
          tag: 'GroupRepository',
        );
        return Right(groupModel.toEntity());
      } on NotFoundException catch (e) {
        Logger.warning(
          'Group not found: $groupId',
          tag: 'GroupRepository',
        );
        return Left(NotFoundFailure(e.message));
      } on ServerException catch (e) {
        Logger.error(
          'Server error while fetching group: $groupId',
          tag: 'GroupRepository',
          error: e,
        );
        return Left(ServerFailure(e.message));
      }
    } else {
      Logger.warning('No internet connection', tag: 'GroupRepository');
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroupsByHost(String hostId) async {
    if (await networkInfo.isConnected) {
      try {
        final groupModels = await remoteDataSource.getGroupsByHost(hostId);
        return Right(groupModels.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroupsByMember(String memberId) async {
    if (await networkInfo.isConnected) {
      try {
        Logger.info('Fetching groups for member: $memberId', tag: 'GroupRepository');
        final groupModels = await remoteDataSource.getGroupsByMember(memberId);
        Logger.success('Fetched ${groupModels.length} groups for member', tag: 'GroupRepository');
        return Right(groupModels.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        Logger.error('Server error while fetching groups for member', tag: 'GroupRepository', error: e);
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group) async {
    if (await networkInfo.isConnected) {
      try {
        final groupModel = GroupModel.fromEntity(group);
        final createdGroup = await remoteDataSource.createGroup(groupModel);
        return Right(createdGroup.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> updateGroup(GroupEntity group) async {
    if (await networkInfo.isConnected) {
      try {
        final groupModel = GroupModel.fromEntity(group);
        final updatedGroup = await remoteDataSource.updateGroup(groupModel);
        return Right(updatedGroup.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String groupId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteGroup(groupId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> joinGroup(String groupId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.joinGroup(groupId, userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveGroup(String groupId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.leaveGroup(groupId, userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<void> incrementViewCount(String groupId) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.incrementViewCount(groupId);
    }
  }
}
