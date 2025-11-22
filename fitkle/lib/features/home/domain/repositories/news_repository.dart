import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/home/domain/entities/news.dart';

/// News Repository Interface - Domain Layer
/// 비즈니스 로직이 의존하는 추상 계약
abstract class NewsRepository {
  /// 모든 뉴스 가져오기 (최신순)
  Future<Either<Failure, List<News>>> getAllNews();

  /// ID로 뉴스 상세 조회
  Future<Either<Failure, News>> getNewsById(String id);

  /// 좋아요 토글
  Future<Either<Failure, News>> toggleLike(String id, bool isLiked);

  /// 카테고리별 뉴스 가져오기
  Future<Either<Failure, List<News>>> getNewsByCategory(String category);

  /// 최근 N개 뉴스 가져오기
  Future<Either<Failure, List<News>>> getRecentNews({int limit = 5});
}
