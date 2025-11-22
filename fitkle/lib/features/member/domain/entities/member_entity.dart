import 'package:equatable/equatable.dart';

/// Member entity matching Supabase 'user' table
class MemberEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final String? nationality;
  final int reviewsCount;
  final int hostedEvents;
  final int attendedEvents;
  final int totalRsvps;
  final int trustScore;
  final String trustLevel;
  final bool isVerified;
  final List<String> interests;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MemberEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.bio,
    this.location,
    this.nationality,
    this.reviewsCount = 0,
    this.hostedEvents = 0,
    this.attendedEvents = 0,
    this.totalRsvps = 0,
    this.trustScore = 0,
    this.trustLevel = 'New',
    this.isVerified = false,
    this.interests = const [],
    this.createdAt,
    this.updatedAt,
  });

  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatarUrl,
        bio,
        location,
        nationality,
        reviewsCount,
        hostedEvents,
        attendedEvents,
        totalRsvps,
        trustScore,
        trustLevel,
        isVerified,
        interests,
        createdAt,
        updatedAt,
      ];
}
