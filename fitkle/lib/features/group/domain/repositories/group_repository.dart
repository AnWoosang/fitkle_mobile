import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';

abstract class GroupRepository {
  Future<Either<Failure, List<GroupEntity>>> getGroups({
    String? category,
    String? searchQuery,
    int limit = 30,
    int offset = 0,
  });

  Future<Either<Failure, GroupEntity>> getGroupById(String groupId);

  Future<Either<Failure, List<GroupEntity>>> getGroupsByHost(String hostId);

  Future<Either<Failure, List<GroupEntity>>> getGroupsByMember(String memberId);

  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group);

  Future<Either<Failure, GroupEntity>> updateGroup(GroupEntity group);

  Future<Either<Failure, void>> deleteGroup(String groupId);

  Future<Either<Failure, void>> joinGroup(String groupId, String userId);

  Future<Either<Failure, void>> leaveGroup(String groupId, String userId);

  Future<void> incrementViewCount(String groupId);
}
