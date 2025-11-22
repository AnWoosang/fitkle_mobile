import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/member/domain/entities/member_entity.dart';

abstract class MemberRepository {
  Future<Either<Failure, MemberEntity>> getMemberById(String userId);

  Future<Either<Failure, MemberEntity>> updateMember(MemberEntity user);

  Future<Either<Failure, void>> updateAvatar(String userId, String avatarUrl);

  Future<Either<Failure, List<MemberEntity>>> searchMembers(String query);

  Future<Either<Failure, bool>> checkNicknameAvailability(String nickname);

  Future<Either<Failure, bool>> checkEmailAvailability(String email);
}
