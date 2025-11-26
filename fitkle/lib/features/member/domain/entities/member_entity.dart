import 'package:equatable/equatable.dart';
import 'package:fitkle/features/member/domain/enums/gender.dart';
import 'package:fitkle/features/member/domain/enums/country.dart';
import 'package:fitkle/features/member/domain/models/interest.dart';

/// Member entity matching Supabase 'member' table
class MemberEntity extends Equatable {
  final String id;
  final String email;
  final String? nickname;
  final String? phone;
  final Gender? gender;
  final String? avatarUrl;
  final String? bio;
  final String location;
  final Country nationality;
  final int hostedEvents;
  final int attendedEvents;
  final int totalRsvps;
  final bool isVerified;
  final DateTime? nicknameUpdatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  // Social media handles
  final String? facebookHandle;
  final String? instagramHandle;
  final String? twitterHandle;
  final String? linkedinHandle;
  final String? emailHandle;

  // User interests (from member_interests join table)
  final List<Interest> interests;

  const MemberEntity({
    required this.id,
    required this.email,
    this.nickname,
    this.phone,
    this.gender,
    this.avatarUrl,
    this.bio,
    required this.location,
    required this.nationality,
    this.hostedEvents = 0,
    this.attendedEvents = 0,
    this.totalRsvps = 0,
    this.isVerified = false,
    this.nicknameUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.facebookHandle,
    this.instagramHandle,
    this.twitterHandle,
    this.linkedinHandle,
    this.emailHandle,
    this.interests = const [],
  });

  /// 표시용 이름 (nickname이 없으면 email 앞부분 사용)
  String get displayName {
    if (nickname != null && nickname!.isNotEmpty) {
      return nickname!;
    }
    return email.split('@').first;
  }

  /// 이니셜 (프로필 아바타용)
  String get initials {
    final name = displayName;
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  /// 소프트 삭제 여부
  bool get isDeleted => deletedAt != null;

  @override
  List<Object?> get props => [
        id,
        email,
        nickname,
        phone,
        gender,
        avatarUrl,
        bio,
        location,
        nationality,
        hostedEvents,
        attendedEvents,
        totalRsvps,
        isVerified,
        nicknameUpdatedAt,
        createdAt,
        updatedAt,
        deletedAt,
        facebookHandle,
        instagramHandle,
        twitterHandle,
        linkedinHandle,
        emailHandle,
        interests,
      ];
}
