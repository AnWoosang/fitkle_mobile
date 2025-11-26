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
  /// [memberId] 조회할 멤버 ID
  /// 반환: 성공 시 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> getMemberById(String memberId) async {
    return await _repository.getMemberById(memberId);
  }

  /// 이메일로 멤버 조회
  ///
  /// [email] 조회할 멤버 이메일
  /// 반환: 성공 시 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> getMemberByEmail(String email) async {
    return await _repository.getMemberByEmail(email);
  }

  /// 새 멤버 생성
  ///
  /// [member] 생성할 멤버 정보
  /// 반환: 성공 시 생성된 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> createMember(MemberEntity member) async {
    return await _repository.createMember(member);
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
  /// [memberId] 멤버 ID
  /// [avatarUrl] 새로운 아바타 URL
  /// 반환: 성공 시 void, 실패 시 Failure
  Future<Either<Failure, void>> updateAvatar(String memberId, String avatarUrl) async {
    return await _repository.updateAvatar(memberId, avatarUrl);
  }

  /// 멤버 소프트 삭제
  ///
  /// [memberId] 삭제할 멤버 ID
  /// 반환: 성공 시 void, 실패 시 Failure
  Future<Either<Failure, void>> softDeleteMember(String memberId) async {
    return await _repository.softDeleteMember(memberId);
  }

  /// 멤버 검색
  ///
  /// [query] 검색어 (닉네임 또는 이메일)
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

  /// 전체 멤버 목록 조회 (페이징)
  ///
  /// [limit] 한 번에 가져올 멤버 수 (기본값: 50)
  /// [offset] 시작 위치 (기본값: 0)
  /// 반환: 성공 시 멤버 리스트, 실패 시 Failure
  Future<Either<Failure, List<MemberEntity>>> getAllMembers({int limit = 50, int offset = 0}) async {
    return await _repository.getAllMembers(limit: limit, offset: offset);
  }
}
