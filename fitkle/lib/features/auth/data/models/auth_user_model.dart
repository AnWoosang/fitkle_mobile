import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:fitkle/features/auth/domain/entities/auth_user_entity.dart';

class AuthUserModel {
  final String id;
  final String email;
  final String? nickname;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final String? nationality;
  final bool isEmailConfirmed;
  final bool isVerified;
  final DateTime? lastSignInAt;
  final DateTime createdAt;

  const AuthUserModel({
    required this.id,
    required this.email,
    this.nickname,
    this.phone,
    this.avatarUrl,
    this.bio,
    this.location,
    this.nationality,
    this.isEmailConfirmed = false,
    this.isVerified = false,
    this.lastSignInAt,
    required this.createdAt,
  });

  /// Supabase auth.users 정보만으로 생성 (로그인 직후)
  factory AuthUserModel.fromSupabaseUser(supabase.User user) {
    return AuthUserModel(
      id: user.id,
      email: user.email ?? '',
      nickname: user.userMetadata?['nickname'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
      isEmailConfirmed: user.emailConfirmedAt != null,
      lastSignInAt: user.lastSignInAt != null
          ? DateTime.parse(user.lastSignInAt!)
          : null,
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  /// Supabase auth.users와 member 테이블 데이터를 결합하여 생성
  factory AuthUserModel.fromSupabaseUserWithMember(
    supabase.User user,
    Map<String, dynamic>? memberData,
  ) {
    return AuthUserModel(
      id: user.id,
      email: user.email ?? '',
      nickname: memberData?['nickname'] as String?,
      phone: memberData?['phone'] as String?,
      avatarUrl: memberData?['avatar_url'] as String?,
      bio: memberData?['bio'] as String?,
      location: memberData?['location'] as String?,
      nationality: memberData?['nationality'] as String?,
      isEmailConfirmed: user.emailConfirmedAt != null,
      isVerified: memberData?['is_verified'] as bool? ?? false,
      lastSignInAt: user.lastSignInAt != null
          ? DateTime.parse(user.lastSignInAt!)
          : null,
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  /// member 테이블 데이터로부터 생성
  factory AuthUserModel.fromMemberJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      nationality: json['nationality'] as String?,
      isEmailConfirmed: true, // member 테이블에 있으면 이메일 확인된 것으로 간주
      isVerified: json['is_verified'] as bool? ?? false,
      lastSignInAt: null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'phone': phone,
      'avatar_url': avatarUrl,
      'bio': bio,
      'location': location,
      'nationality': nationality,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// 회원가입 시 member 테이블에 삽입할 데이터
  Map<String, dynamic> toInsertJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'phone': phone,
      'avatar_url': avatarUrl,
      'bio': bio,
      'location': location ?? 'Seoul',
      'nationality': nationality ?? 'KR',
      'is_verified': isVerified,
    };
  }

  /// Convert Model to Entity (Data Layer → Domain Layer)
  AuthUserEntity toEntity() {
    return AuthUserEntity(
      id: id,
      email: email,
      nickname: nickname,
      phone: phone,
      avatarUrl: avatarUrl,
      bio: bio,
      location: location,
      nationality: nationality,
      isEmailConfirmed: isEmailConfirmed,
      isVerified: isVerified,
      lastSignInAt: lastSignInAt,
      createdAt: createdAt,
    );
  }

  /// Create Model from Entity (Domain Layer → Data Layer)
  factory AuthUserModel.fromEntity(AuthUserEntity entity) {
    return AuthUserModel(
      id: entity.id,
      email: entity.email,
      nickname: entity.nickname,
      phone: entity.phone,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      location: entity.location,
      nationality: entity.nationality,
      isEmailConfirmed: entity.isEmailConfirmed,
      isVerified: entity.isVerified,
      lastSignInAt: entity.lastSignInAt,
      createdAt: entity.createdAt,
    );
  }
}
