import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';
import 'package:fitkle/features/group/domain/repositories/group_repository.dart';

class GroupService {
  final GroupRepository _repository;

  GroupService(this._repository);

  Future<Either<Failure, List<GroupEntity>>> getGroups({
    String? category,
    String? searchQuery,
    int limit = 30,
    int offset = 0,
  }) async {
    return await _repository.getGroups(
      category: category,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
  }

  Future<Either<Failure, GroupEntity>> getGroupById(String groupId) async {
    return await _repository.getGroupById(groupId);
  }

  Future<Either<Failure, List<GroupEntity>>> getGroupsByHost(String hostId) async {
    return await _repository.getGroupsByHost(hostId);
  }

  Future<Either<Failure, List<GroupEntity>>> getGroupsByMember(String memberId) async {
    return await _repository.getGroupsByMember(memberId);
  }

  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group) async {
    return await _repository.createGroup(group);
  }

  Future<Either<Failure, GroupEntity>> updateGroup(GroupEntity group) async {
    return await _repository.updateGroup(group);
  }

  Future<Either<Failure, void>> deleteGroup(String groupId) async {
    return await _repository.deleteGroup(groupId);
  }

  Future<Either<Failure, void>> joinGroup(String groupId, String userId) async {
    return await _repository.joinGroup(groupId, userId);
  }

  Future<Either<Failure, void>> leaveGroup(String groupId, String userId) async {
    return await _repository.leaveGroup(groupId, userId);
  }

  Future<void> incrementViewCount(String groupId) async {
    await _repository.incrementViewCount(groupId);
  }
}
