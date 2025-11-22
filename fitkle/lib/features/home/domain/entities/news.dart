import 'package:equatable/equatable.dart';
import 'package:fitkle/features/home/domain/entities/news_category.dart';

/// News Entity - 순수 비즈니스 객체
class News extends Equatable {
  final String id;
  final String title;
  final String content;
  final NewsCategory category;
  final String author;
  final String? thumbnailImageUrl;
  final int likeCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const News({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.author,
    this.thumbnailImageUrl,
    this.likeCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 비즈니스 로직: 최근 뉴스인지 확인 (7일 이내)
  bool get isRecent => DateTime.now().difference(createdAt).inDays < 7;

  /// 비즈니스 로직: 좋아요 여부 확인
  bool get hasLikes => likeCount > 0;

  News copyWith({
    String? id,
    String? title,
    String? content,
    NewsCategory? category,
    String? author,
    String? thumbnailImageUrl,
    int? likeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      author: author ?? this.author,
      thumbnailImageUrl: thumbnailImageUrl ?? this.thumbnailImageUrl,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        category,
        author,
        thumbnailImageUrl,
        likeCount,
        createdAt,
        updatedAt,
      ];
}
