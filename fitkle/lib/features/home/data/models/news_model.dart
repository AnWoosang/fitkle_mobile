import 'package:fitkle/features/home/domain/entities/news.dart';
import 'package:fitkle/features/home/domain/entities/news_category.dart';

/// News Model - Data Layer (DB 매핑)
class NewsModel extends News {
  const NewsModel({
    required super.id,
    required super.title,
    required super.content,
    required super.category,
    required super.author,
    super.thumbnailImageUrl,
    super.likeCount = 0,
    required super.createdAt,
    required super.updatedAt,
  });

  /// JSON → Model (Supabase에서 가져온 데이터)
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: NewsCategory.fromString(json['category'] as String),
      author: json['author'] as String,
      thumbnailImageUrl: json['thumbnail_image_url'] as String?,
      likeCount: json['like_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Model → JSON (Supabase로 전송)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category.value,
      'author': author,
      'thumbnail_image_url': thumbnailImageUrl,
      'like_count': likeCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Entity → Model 변환
  factory NewsModel.fromEntity(News entity) {
    return NewsModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      category: entity.category,
      author: entity.author,
      thumbnailImageUrl: entity.thumbnailImageUrl,
      likeCount: entity.likeCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
