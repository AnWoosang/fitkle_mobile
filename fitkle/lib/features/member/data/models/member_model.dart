import 'package:fitkle/features/member/domain/entities/member_entity.dart';
import 'package:fitkle/features/member/domain/enums/gender.dart';
import 'package:fitkle/features/member/domain/enums/country.dart';
import 'package:fitkle/features/member/domain/models/interest.dart';
import 'package:fitkle/features/member/domain/models/preference.dart';

class MemberModel {
  final String id;
  final String email;
  final String? nickname;
  final String? phone;
  final String? gender; // DB에서 문자열로 저장 (예: 'male', 'female', 'other')
  final String? avatarUrl;
  final String? bio;
  final DateTime? birthdate;
  final String location;
  final String nationality; // DB에서 문자열 코드로 저장 (예: 'KR', 'US', 'JP')
  final int hostedEvents;
  final int attendedEvents;
  final int totalRsvps;
  final bool isVerified;
  final DateTime? nicknameUpdatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? facebookHandle;
  final String? instagramHandle;
  final String? twitterHandle;
  final String? linkedinHandle;
  final String? emailHandle;

  // User interests (from member_interests join)
  final List<Interest> interests;

  // User preferences (from member_preference join)
  final List<Preference> preferences;

  const MemberModel({
    required this.id,
    required this.email,
    this.nickname,
    this.phone,
    this.gender,
    this.avatarUrl,
    this.bio,
    this.birthdate,
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
    this.preferences = const [],
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    // Parse interests from join query result
    List<Interest> parsedInterests = [];
    if (json['interests'] != null && json['interests'] is List) {
      parsedInterests = (json['interests'] as List)
          .map((interestJson) => Interest.fromJson(interestJson as Map<String, dynamic>))
          .toList();
    }

    // Parse preferences from join query result
    List<Preference> parsedPreferences = [];
    if (json['preferences'] != null && json['preferences'] is List) {
      parsedPreferences = (json['preferences'] as List)
          .map((preferenceJson) => Preference.fromJson(preferenceJson as Map<String, dynamic>))
          .toList();
    }

    return MemberModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?, // DB에서 그대로 문자열로 받음
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      birthdate: json['birthdate'] != null
          ? DateTime.parse(json['birthdate'] as String)
          : null,
      location: json['location'] as String,
      nationality: json['nationality'] as String, // DB에서 그대로 문자열 코드로 받음
      hostedEvents: (json['hosted_events'] as num?)?.toInt() ?? 0,
      attendedEvents: (json['attended_events'] as num?)?.toInt() ?? 0,
      totalRsvps: (json['total_rsvps'] as num?)?.toInt() ?? 0,
      isVerified: json['is_verified'] as bool? ?? false,
      nicknameUpdatedAt: json['nickname_updated_at'] != null
          ? DateTime.parse(json['nickname_updated_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      facebookHandle: json['facebook_handle'] as String?,
      instagramHandle: json['instagram_handle'] as String?,
      twitterHandle: json['twitter_handle'] as String?,
      linkedinHandle: json['linkedin_handle'] as String?,
      emailHandle: json['email_handle'] as String?,
      interests: parsedInterests,
      preferences: parsedPreferences,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'phone': phone,
      'gender': gender, // 문자열 그대로 저장
      'avatar_url': avatarUrl,
      'bio': bio,
      'birthdate': birthdate?.toIso8601String().split('T')[0], // DATE 타입은 날짜만
      'location': location,
      'nationality': nationality, // 문자열 코드 그대로 저장
      'hosted_events': hostedEvents,
      'attended_events': attendedEvents,
      'total_rsvps': totalRsvps,
      'is_verified': isVerified,
      'nickname_updated_at': nicknameUpdatedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'facebook_handle': facebookHandle,
      'instagram_handle': instagramHandle,
      'twitter_handle': twitterHandle,
      'linkedin_handle': linkedinHandle,
      'email_handle': emailHandle,
    };
  }

  /// Insert용 JSON (id, created_at, updated_at 제외)
  Map<String, dynamic> toInsertJson() {
    return {
      'email': email,
      'nickname': nickname,
      'phone': phone,
      'gender': gender, // 문자열 그대로
      'avatar_url': avatarUrl,
      'bio': bio,
      'birthdate': birthdate?.toIso8601String().split('T')[0], // DATE 타입은 날짜만
      'location': location,
      'nationality': nationality, // 문자열 코드 그대로
      'facebook_handle': facebookHandle,
      'instagram_handle': instagramHandle,
      'twitter_handle': twitterHandle,
      'linkedin_handle': linkedinHandle,
      'email_handle': emailHandle,
    };
  }

  /// Update용 JSON (수정 가능한 필드만)
  Map<String, dynamic> toUpdateJson() {
    return {
      'nickname': nickname,
      'phone': phone,
      'gender': gender, // 문자열 그대로
      'avatar_url': avatarUrl,
      'bio': bio,
      'birthdate': birthdate?.toIso8601String().split('T')[0], // DATE 타입은 날짜만
      'location': location,
      'nationality': nationality, // 문자열 코드 그대로
      'facebook_handle': facebookHandle,
      'instagram_handle': instagramHandle,
      'twitter_handle': twitterHandle,
      'linkedin_handle': linkedinHandle,
      'email_handle': emailHandle,
    };
  }

  /// Convert Model to Entity (Data Layer → Domain Layer)
  /// 여기서 String → Enum 변환이 일어남
  MemberEntity toEntity() {
    return MemberEntity(
      id: id,
      email: email,
      nickname: nickname,
      phone: phone,
      gender: Gender.fromDatabaseValue(gender), // String → Gender enum
      avatarUrl: avatarUrl,
      bio: bio,
      birthdate: birthdate,
      location: location,
      nationality: Country.fromCode(nationality) ?? Country.southKorea, // String → Country enum
      hostedEvents: hostedEvents,
      attendedEvents: attendedEvents,
      totalRsvps: totalRsvps,
      isVerified: isVerified,
      nicknameUpdatedAt: nicknameUpdatedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      facebookHandle: facebookHandle,
      instagramHandle: instagramHandle,
      twitterHandle: twitterHandle,
      linkedinHandle: linkedinHandle,
      emailHandle: emailHandle,
      interests: interests, // Interest 객체는 그대로 전달
      preferences: preferences, // Preference 객체는 그대로 전달
    );
  }

  /// Create Model from Entity (Domain Layer → Data Layer)
  /// 여기서 Enum → String 변환이 일어남
  factory MemberModel.fromEntity(MemberEntity entity) {
    return MemberModel(
      id: entity.id,
      email: entity.email,
      nickname: entity.nickname,
      phone: entity.phone,
      gender: entity.gender?.toDatabaseValue(), // Gender enum → String
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      birthdate: entity.birthdate,
      location: entity.location,
      nationality: entity.nationality.code, // Country enum → String
      hostedEvents: entity.hostedEvents,
      attendedEvents: entity.attendedEvents,
      totalRsvps: entity.totalRsvps,
      isVerified: entity.isVerified,
      nicknameUpdatedAt: entity.nicknameUpdatedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      facebookHandle: entity.facebookHandle,
      instagramHandle: entity.instagramHandle,
      twitterHandle: entity.twitterHandle,
      linkedinHandle: entity.linkedinHandle,
      emailHandle: entity.emailHandle,
      interests: entity.interests, // Interest 객체는 그대로 전달
      preferences: entity.preferences, // Preference 객체는 그대로 전달
    );
  }

  /// 필드 업데이트를 위한 copyWith
  MemberModel copyWith({
    String? id,
    String? email,
    String? nickname,
    String? phone,
    String? gender, // String 타입으로 변경
    String? avatarUrl,
    String? bio,
    DateTime? birthdate,
    String? location,
    String? nationality, // String 타입으로 변경
    int? hostedEvents,
    int? attendedEvents,
    int? totalRsvps,
    bool? isVerified,
    DateTime? nicknameUpdatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? facebookHandle,
    String? instagramHandle,
    String? twitterHandle,
    String? linkedinHandle,
    String? emailHandle,
    List<Interest>? interests,
    List<Preference>? preferences,
  }) {
    return MemberModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      birthdate: birthdate ?? this.birthdate,
      location: location ?? this.location,
      nationality: nationality ?? this.nationality,
      hostedEvents: hostedEvents ?? this.hostedEvents,
      attendedEvents: attendedEvents ?? this.attendedEvents,
      totalRsvps: totalRsvps ?? this.totalRsvps,
      isVerified: isVerified ?? this.isVerified,
      nicknameUpdatedAt: nicknameUpdatedAt ?? this.nicknameUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      facebookHandle: facebookHandle ?? this.facebookHandle,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      linkedinHandle: linkedinHandle ?? this.linkedinHandle,
      emailHandle: emailHandle ?? this.emailHandle,
      interests: interests ?? this.interests,
      preferences: preferences ?? this.preferences,
    );
  }
}
