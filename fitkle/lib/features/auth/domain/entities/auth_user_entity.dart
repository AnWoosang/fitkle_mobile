import 'package:equatable/equatable.dart';

/// 인증된 사용자 정보를 담는 엔티티
/// Supabase auth.users와 public.member 테이블의 정보를 포함
class AuthUserEntity extends Equatable {
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

  const AuthUserEntity({
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

  /// 프로필이 완성되었는지 확인
  bool get isProfileComplete {
    return nickname != null &&
           nickname!.isNotEmpty &&
           location != null &&
           nationality != null;
  }

  AuthUserEntity copyWith({
    String? id,
    String? email,
    String? nickname,
    String? phone,
    String? avatarUrl,
    String? bio,
    String? location,
    String? nationality,
    bool? isEmailConfirmed,
    bool? isVerified,
    DateTime? lastSignInAt,
    DateTime? createdAt,
  }) {
    return AuthUserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      nationality: nationality ?? this.nationality,
      isEmailConfirmed: isEmailConfirmed ?? this.isEmailConfirmed,
      isVerified: isVerified ?? this.isVerified,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        nickname,
        phone,
        avatarUrl,
        bio,
        location,
        nationality,
        isEmailConfirmed,
        isVerified,
        lastSignInAt,
        createdAt,
      ];
}
