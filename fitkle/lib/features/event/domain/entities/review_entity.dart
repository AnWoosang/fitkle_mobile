import 'package:equatable/equatable.dart';

/// Review entity matching Supabase 'review' table
class ReviewEntity extends Equatable {
  final String id;
  final String eventId;
  final String reviewerId;
  final int rating; // 1-5
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const ReviewEntity({
    required this.id,
    required this.eventId,
    required this.reviewerId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  bool get isDeleted => deletedAt != null;

  @override
  List<Object?> get props => [
        id,
        eventId,
        reviewerId,
        rating,
        comment,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
