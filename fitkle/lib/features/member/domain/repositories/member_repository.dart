import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/member/domain/entities/member_entity.dart';

abstract class MemberRepository {
  Future<Either<Failure, MemberEntity>> getMemberById(String memberId);

  Future<Either<Failure, MemberEntity>> getMemberByEmail(String email);

  Future<Either<Failure, MemberEntity>> createMember(MemberEntity member);

  Future<Either<Failure, MemberEntity>> updateMember(MemberEntity member);

  Future<Either<Failure, void>> updateAvatar(String memberId, String avatarUrl);

  Future<Either<Failure, void>> softDeleteMember(String memberId);

  Future<Either<Failure, List<MemberEntity>>> searchMembers(String query);

  Future<Either<Failure, bool>> checkNicknameAvailability(String nickname);

  Future<Either<Failure, bool>> checkEmailAvailability(String email);

  Future<Either<Failure, List<MemberEntity>>> getAllMembers({int limit = 50, int offset = 0});

  Future<Either<Failure, MemberEntity>> patchMemberField(String memberId, Map<String, dynamic> updates);
}
