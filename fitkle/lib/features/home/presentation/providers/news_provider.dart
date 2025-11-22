import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/features/home/domain/entities/news.dart';
import 'package:fitkle/features/home/domain/repositories/news_repository.dart';
import 'package:fitkle/features/home/data/repositories/news_repository_impl.dart';
import 'package:fitkle/features/home/data/datasources/news_remote_datasource.dart';
import 'package:fitkle/core/network/network_info.dart';
import 'package:fitkle/core/utils/logger.dart';

// ============================================================================
// DEPENDENCY INJECTION - News Feature
// ============================================================================

// Core Dependencies
final _newsNetworkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

// Data Sources
final newsRemoteDatasourceProvider = Provider<NewsRemoteDatasource>((ref) {
  return NewsRemoteDatasourceImpl();
});

// Repositories
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    ref.watch(newsRemoteDatasourceProvider),
    ref.watch(_newsNetworkInfoProvider),
  );
});

// ============================================================================
// STATE MANAGEMENT
// ============================================================================

/// News 상태
class NewsState {
  final List<News> newsList;
  final bool isLoading;
  final String? error;

  const NewsState({
    this.newsList = const [],
    this.isLoading = false,
    this.error,
  });

  NewsState copyWith({
    List<News>? newsList,
    bool? isLoading,
    String? error,
  }) {
    return NewsState(
      newsList: newsList ?? this.newsList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// News StateNotifier
class NewsNotifier extends StateNotifier<NewsState> {
  final NewsRepository _repository;

  // 캐싱을 위한 필드
  DateTime? _lastFetchTime;
  static const staleDuration = Duration(hours: 1); // 1시간 캐시 유지

  NewsNotifier(this._repository) : super(const NewsState());

  /// 모든 뉴스 로드
  Future<void> loadNews({bool forceRefresh = false}) async {
    // Stale time 체크 - 캐시가 유효하면 API 호출 스킵
    if (!forceRefresh && _lastFetchTime != null) {
      final now = DateTime.now();
      final timeSinceLastFetch = now.difference(_lastFetchTime!);

      if (timeSinceLastFetch < staleDuration && state.newsList.isNotEmpty) {
        Logger.info(
          'Using cached news (${timeSinceLastFetch.inMinutes} minutes old)',
          tag: 'NewsProvider',
        );
        return; // 캐시된 데이터 사용
      }
    }

    Logger.info('Loading all news from API...', tag: 'NewsProvider');
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getAllNews();

    result.fold(
      (failure) {
        Logger.error(
          'Failed to load news: ${failure.message}',
          tag: 'NewsProvider',
          error: failure,
        );
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (newsList) {
        _lastFetchTime = DateTime.now(); // 캐시 시간 업데이트
        Logger.success(
          'Loaded ${newsList.length} news from API',
          tag: 'NewsProvider',
        );
        state = state.copyWith(
          newsList: newsList,
          isLoading: false,
        );
      },
    );
  }

  /// 뉴스 새로고침 (강제로 새로운 데이터 가져오기)
  Future<void> refreshNews() async {
    await loadNews(forceRefresh: true);
  }

  /// 좋아요 토글
  Future<void> toggleLike(String newsId, bool isCurrentlyLiked) async {
    final result = await _repository.toggleLike(newsId, !isCurrentlyLiked);

    result.fold(
      (failure) {
        Logger.error(
          'Failed to toggle like: ${failure.message}',
          tag: 'NewsProvider',
          error: failure,
        );
        state = state.copyWith(error: failure.message);
      },
      (updatedNews) {
        // 상태 업데이트
        final updatedList = state.newsList.map((news) {
          return news.id == newsId ? updatedNews : news;
        }).toList();

        state = state.copyWith(newsList: updatedList);
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ============================================================================
// STATE PROVIDERS
// ============================================================================

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  ref.keepAlive(); // Provider가 dispose되지 않도록 유지 (메모리 캐싱)
  return NewsNotifier(ref.watch(newsRepositoryProvider));
});

/// 특정 뉴스 조회 Provider
final newsDetailProvider = FutureProvider.family<News, String>((ref, newsId) async {
  final repository = ref.watch(newsRepositoryProvider);
  final result = await repository.getNewsById(newsId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (news) => news,
  );
});
