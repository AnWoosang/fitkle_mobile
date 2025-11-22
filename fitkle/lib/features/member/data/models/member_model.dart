import 'package:fitkle/features/member/domain/entities/member_entity.dart';

class MemberModel extends MemberEntity {
  const MemberModel({
    required super.id,
    required super.email,
    required super.name,
    super.avatarUrl,
    super.bio,
    super.location,
    super.nationality,
    super.reviewsCount = 0,
    super.hostedEvents = 0,
    super.attendedEvents = 0,
    super.totalRsvps = 0,
    super.trustScore = 0,
    super.trustLevel = 'New',
    super.isVerified = false,
    super.interests = const [],
    super.createdAt,
    super.updatedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    // Parse interests from JSONB
    List<String> parsedInterests = [];
    if (json['interests'] != null) {
      if (json['interests'] is List) {
        parsedInterests = List<String>.from(json['interests']);
      }
    }

    return MemberModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      nationality: json['nationality'] as String?,
      reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,
      hostedEvents: (json['hosted_events'] as num?)?.toInt() ?? 0,
      attendedEvents: (json['attended_events'] as num?)?.toInt() ?? 0,
      totalRsvps: (json['total_rsvps'] as num?)?.toInt() ?? 0,
      trustScore: (json['trust_score'] as num?)?.toInt() ?? 0,
      trustLevel: json['trust_level'] as String? ?? 'New',
      isVerified: json['is_verified'] as bool? ?? false,
      interests: parsedInterests,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'bio': bio,
      'location': location,
      'nationality': nationality,
      'reviews_count': reviewsCount,
      'hosted_events': hostedEvents,
      'attended_events': attendedEvents,
      'total_rsvps': totalRsvps,
      'trust_score': trustScore,
      'trust_level': trustLevel,
      'is_verified': isVerified,
      'interests': interests,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory MemberModel.fromEntity(MemberEntity entity) {
    return MemberModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      location: entity.location,
      nationality: entity.nationality,
      reviewsCount: entity.reviewsCount,
      hostedEvents: entity.hostedEvents,
      attendedEvents: entity.attendedEvents,
      totalRsvps: entity.totalRsvps,
      trustScore: entity.trustScore,
      trustLevel: entity.trustLevel,
      isVerified: entity.isVerified,
      interests: entity.interests,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
