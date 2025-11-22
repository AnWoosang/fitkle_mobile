import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/member/domain/entities/member_entity.dart';
import 'package:fitkle/features/member/domain/repositories/member_repository.dart';

/// Member 도메인 서비스
///
/// Member와 관련된 모든 비즈니스 로직을 처리합니다.
/// Repository 패턴을 통해 데이터 계층과 분리되어 있습니다.
class MemberService {
  final MemberRepository _repository;

  MemberService(this._repository);

  /// ID로 멤버 조회
  ///
  /// [userId] 조회할 사용자 ID
  /// 반환: 성공 시 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> getMemberById(String userId) async {
    return await _repository.getMemberById(userId);
  }

  /// 멤버 정보 업데이트
  ///
  /// [member] 업데이트할 멤버 정보
  /// 반환: 성공 시 업데이트된 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> updateMember(MemberEntity member) async {
    return await _repository.updateMember(member);
  }

  /// 멤버 아바타 업데이트
  ///
  /// [userId] 사용자 ID
  /// [avatarUrl] 새로운 아바타 URL
  /// 반환: 성공 시 void, 실패 시 Failure
  Future<Either<Failure, void>> updateAvatar(String userId, String avatarUrl) async {
    return await _repository.updateAvatar(userId, avatarUrl);
  }

  /// 멤버 검색
  ///
  /// [query] 검색어
  /// 반환: 성공 시 검색된 멤버 리스트, 실패 시 Failure
  Future<Either<Failure, List<MemberEntity>>> searchMembers(String query) async {
    return await _repository.searchMembers(query);
  }

  /// 닉네임 중복 확인
  ///
  /// [nickname] 확인할 닉네임
  /// 반환: 성공 시 사용 가능 여부 (true: 사용 가능, false: 이미 사용 중), 실패 시 Failure
  Future<Either<Failure, bool>> checkNicknameAvailability(String nickname) async {
    return await _repository.checkNicknameAvailability(nickname);
  }

  /// 이메일 중복 확인
  ///
  /// [email] 확인할 이메일
  /// 반환: 성공 시 사용 가능 여부 (true: 사용 가능, false: 이미 사용 중), 실패 시 Failure
  Future<Either<Failure, bool>> checkEmailAvailability(String email) async {
    return await _repository.checkEmailAvailability(email);
  }
}
