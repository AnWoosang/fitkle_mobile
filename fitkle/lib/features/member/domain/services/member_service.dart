import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/member/domain/entities/member_entity.dart';
import 'package:fitkle/features/member/domain/repositories/member_repository.dart';
import 'package:fitkle/features/member/domain/services/preference_service.dart';

/// Member 도메인 서비스
///
/// Member와 관련된 모든 비즈니스 로직을 처리합니다.
/// Repository 패턴을 통해 데이터 계층과 분리되어 있습니다.
class MemberService {
  final MemberRepository _repository;
  final PreferenceService _preferenceService;

  MemberService(this._repository, this._preferenceService);

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

  /// 프로필 정보 업데이트 (닉네임, 위치, 선호 카테고리)
  ///
  /// [memberId] 업데이트할 멤버 ID
  /// [nickname] 새로운 닉네임 (선택)
  /// [location] 새로운 위치 (선택)
  /// [preferenceIds] 새로운 선호 카테고리 ID 목록 (선택, null이면 업데이트 안 함)
  /// [avatarUrl] 새로운 아바타 URL (선택)
  ///
  /// 반환: 성공 시 업데이트된 MemberEntity, 실패 시 Failure
  ///
  /// 참고:
  /// - 프로필 사진 변경 시에는 먼저 Storage에 이미지를 업로드하고
  ///   받은 URL을 avatarUrl 파라미터로 전달해야 합니다.
  /// - 선호 카테고리는 기존 항목을 모두 삭제하고 새로 추가하는 방식으로 업데이트됩니다.
  ///
  /// TODO: Storage 이미지 업로드 기능 통합 필요
  /// - StorageService를 통해 이미지 파일을 업로드하고
  /// - 업로드된 URL을 avatarUrl로 사용하도록 구현
  Future<Either<Failure, MemberEntity>> updateProfile({
    required String memberId,
    String? nickname,
    String? location,
    List<String>? preferenceIds,
    String? avatarUrl,
  }) async {
    try {
      // 1. 먼저 현재 멤버 정보 조회
      final memberResult = await getMemberById(memberId);

      return await memberResult.fold(
        (failure) => Left(failure),
        (currentMember) async {
          // 2. 업데이트할 멤버 엔티티 생성
          final updatedMember = MemberEntity(
            id: currentMember.id,
            email: currentMember.email,
            nickname: nickname ?? currentMember.nickname,
            phone: currentMember.phone,
            gender: currentMember.gender,
            avatarUrl: avatarUrl ?? currentMember.avatarUrl,
            bio: currentMember.bio,
            birthdate: currentMember.birthdate,
            location: location ?? currentMember.location,
            nationality: currentMember.nationality,
            hostedEvents: currentMember.hostedEvents,
            attendedEvents: currentMember.attendedEvents,
            totalRsvps: currentMember.totalRsvps,
            isVerified: currentMember.isVerified,
            nicknameUpdatedAt: currentMember.nicknameUpdatedAt,
            createdAt: currentMember.createdAt,
            updatedAt: DateTime.now(),
            deletedAt: currentMember.deletedAt,
            facebookHandle: currentMember.facebookHandle,
            instagramHandle: currentMember.instagramHandle,
            twitterHandle: currentMember.twitterHandle,
            linkedinHandle: currentMember.linkedinHandle,
            emailHandle: currentMember.emailHandle,
            interests: currentMember.interests,
            preferences: currentMember.preferences,
          );

          // 3. 멤버 정보 업데이트 (닉네임, 위치, 아바타)
          final updateResult = await _repository.updateMember(updatedMember);

          return await updateResult.fold(
            (failure) => Left(failure),
            (member) async {
              // 4. 선호 카테고리가 제공된 경우 업데이트
              if (preferenceIds != null) {
                try {
                  await _preferenceService.updateMemberPreferences(memberId, preferenceIds);
                } catch (e) {
                  // 선호 카테고리 업데이트 실패 시 에러 처리
                  return Left(ServerFailure('Failed to update preferences: ${e.toString()}'));
                }
              }

              // 5. 업데이트된 멤버 정보 재조회하여 반환
              return await getMemberById(memberId);
            },
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to update profile: ${e.toString()}'));
    }
  }

  /// SNS 핸들 업데이트
  ///
  /// [memberId] 업데이트할 멤버 ID
  /// [facebookHandle] 페이스북 핸들 (선택)
  /// [instagramHandle] 인스타그램 핸들 (선택)
  /// [twitterHandle] 트위터 핸들 (선택)
  /// [linkedinHandle] 링크드인 핸들 (선택)
  /// [emailHandle] 이메일 핸들 (선택)
  ///
  /// 반환: 성공 시 업데이트된 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> updateSocialMediaHandles({
    required String memberId,
    String? facebookHandle,
    String? instagramHandle,
    String? twitterHandle,
    String? linkedinHandle,
    String? emailHandle,
  }) async {
    try {
      // 1. 현재 멤버 정보 조회
      final memberResult = await getMemberById(memberId);

      return await memberResult.fold(
        (failure) => Left(failure),
        (currentMember) async {
          // 2. 업데이트할 멤버 엔티티 생성
          final updatedMember = MemberEntity(
            id: currentMember.id,
            email: currentMember.email,
            nickname: currentMember.nickname,
            phone: currentMember.phone,
            gender: currentMember.gender,
            avatarUrl: currentMember.avatarUrl,
            bio: currentMember.bio,
            birthdate: currentMember.birthdate,
            location: currentMember.location,
            nationality: currentMember.nationality,
            hostedEvents: currentMember.hostedEvents,
            attendedEvents: currentMember.attendedEvents,
            totalRsvps: currentMember.totalRsvps,
            isVerified: currentMember.isVerified,
            nicknameUpdatedAt: currentMember.nicknameUpdatedAt,
            createdAt: currentMember.createdAt,
            updatedAt: DateTime.now(),
            deletedAt: currentMember.deletedAt,
            facebookHandle: facebookHandle ?? currentMember.facebookHandle,
            instagramHandle: instagramHandle ?? currentMember.instagramHandle,
            twitterHandle: twitterHandle ?? currentMember.twitterHandle,
            linkedinHandle: linkedinHandle ?? currentMember.linkedinHandle,
            emailHandle: emailHandle ?? currentMember.emailHandle,
            interests: currentMember.interests,
            preferences: currentMember.preferences,
          );

          // 3. 멤버 정보 업데이트
          return await _repository.updateMember(updatedMember);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to update social media handles: ${e.toString()}'));
    }
  }

  /// 닉네임 업데이트 (PATCH)
  ///
  /// [memberId] 업데이트할 멤버 ID
  /// [nickname] 새로운 닉네임
  ///
  /// 반환: 성공 시 업데이트된 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> updateNickname(String memberId, String nickname) async {
    return await _repository.patchMemberField(memberId, {
      'nickname': nickname,
      'nickname_updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// 이메일 핸들 업데이트 (PATCH)
  ///
  /// [memberId] 업데이트할 멤버 ID
  /// [emailHandle] 새로운 이메일 핸들
  ///
  /// 반환: 성공 시 업데이트된 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> updateEmailHandle(String memberId, String emailHandle) async {
    return await _repository.patchMemberField(memberId, {
      'email_handle': emailHandle,
    });
  }

  /// 페이스북 핸들 업데이트 (PATCH)
  ///
  /// [memberId] 업데이트할 멤버 ID
  /// [facebookHandle] 새로운 페이스북 핸들
  ///
  /// 반환: 성공 시 업데이트된 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> updateFacebookHandle(String memberId, String facebookHandle) async {
    return await _repository.patchMemberField(memberId, {
      'facebook_handle': facebookHandle,
    });
  }

  /// 인스타그램 핸들 업데이트 (PATCH)
  ///
  /// [memberId] 업데이트할 멤버 ID
  /// [instagramHandle] 새로운 인스타그램 핸들
  ///
  /// 반환: 성공 시 업데이트된 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> updateInstagramHandle(String memberId, String instagramHandle) async {
    return await _repository.patchMemberField(memberId, {
      'instagram_handle': instagramHandle,
    });
  }

  /// 트위터 핸들 업데이트 (PATCH)
  ///
  /// [memberId] 업데이트할 멤버 ID
  /// [twitterHandle] 새로운 트위터 핸들
  ///
  /// 반환: 성공 시 업데이트된 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> updateTwitterHandle(String memberId, String twitterHandle) async {
    return await _repository.patchMemberField(memberId, {
      'twitter_handle': twitterHandle,
    });
  }

  /// 링크드인 핸들 업데이트 (PATCH)
  ///
  /// [memberId] 업데이트할 멤버 ID
  /// [linkedinHandle] 새로운 링크드인 핸들
  ///
  /// 반환: 성공 시 업데이트된 MemberEntity, 실패 시 Failure
  Future<Either<Failure, MemberEntity>> updateLinkedinHandle(String memberId, String linkedinHandle) async {
    return await _repository.patchMemberField(memberId, {
      'linkedin_handle': linkedinHandle,
    });
  }
}
