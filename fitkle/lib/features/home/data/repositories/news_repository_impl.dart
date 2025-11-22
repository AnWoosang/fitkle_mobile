import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/core/network/network_info.dart';
import 'package:fitkle/features/home/domain/entities/news.dart';
import 'package:fitkle/features/home/domain/repositories/news_repository.dart';
import 'package:fitkle/features/home/data/datasources/news_remote_datasource.dart';

/// News Repository Implementation - Data Layer
/// Domain의 Repository 인터페이스를 구현하여 Data Source와 연결
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  NewsRepositoryImpl(this._remoteDatasource, this._networkInfo);

  @override
  Future<Either<Failure, List<News>>> getAllNews() async {
    if (await _networkInfo.isConnected) {
      try {
        final newsModels = await _remoteDatasource.getAllNews();
        return Right(newsModels);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, News>> getNewsById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final newsModel = await _remoteDatasource.getNewsById(id);
        return Right(newsModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, News>> toggleLike(String id, bool isLiked) async {
    if (await _networkInfo.isConnected) {
      try {
        // 현재 뉴스 정보 가져오기
        final newsResult = await getNewsById(id);

        return newsResult.fold(
          (failure) => Left(failure),
          (news) async {
            // 좋아요 수 계산
            final newLikeCount = isLiked ? news.likeCount + 1 : news.likeCount - 1;

            // 업데이트된 뉴스 반환
            try {
              final updatedNews = await _remoteDatasource.updateNewsLikeCount(id, newLikeCount);
              return Right(updatedNews);
            } on ServerException catch (e) {
              return Left(ServerFailure(e.message));
            }
          },
        );
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<News>>> getNewsByCategory(String category) async {
    if (await _networkInfo.isConnected) {
      try {
        final newsModels = await _remoteDatasource.getNewsByCategory(category);
        return Right(newsModels);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<News>>> getRecentNews({int limit = 5}) async {
    if (await _networkInfo.isConnected) {
      try {
        final newsModels = await _remoteDatasource.getRecentNews(limit: limit);
        return Right(newsModels);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
