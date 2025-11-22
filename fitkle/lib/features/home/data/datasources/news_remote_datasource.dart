import 'package:fitkle/core/config/supabase_client.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/features/home/data/models/news_model.dart';

/// News Remote Datasource - Supabase API 통신
abstract class NewsRemoteDatasource {
  Future<List<NewsModel>> getAllNews();
  Future<NewsModel> getNewsById(String id);
  Future<NewsModel> updateNewsLikeCount(String id, int newLikeCount);
  Future<List<NewsModel>> getNewsByCategory(String category);
  Future<List<NewsModel>> getRecentNews({int limit = 5});
}

class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  final _supabase = supabaseClient;

  @override
  Future<List<NewsModel>> getAllNews() async {
    try {
      final response = await _supabase
          .from('news')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => NewsModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch news: $e');
    }
  }

  @override
  Future<NewsModel> getNewsById(String id) async {
    try {
      final response = await _supabase
          .from('news')
          .select()
          .eq('id', id)
          .single();

      return NewsModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to fetch news by id: $e');
    }
  }

  @override
  Future<NewsModel> updateNewsLikeCount(String id, int newLikeCount) async {
    try {
      await _supabase
          .from('news')
          .update({'like_count': newLikeCount})
          .eq('id', id);

      return await getNewsById(id);
    } catch (e) {
      throw ServerException('Failed to update like count: $e');
    }
  }

  @override
  Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      final response = await _supabase
          .from('news')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => NewsModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch news by category: $e');
    }
  }

  @override
  Future<List<NewsModel>> getRecentNews({int limit = 5}) async {
    try {
      final response = await _supabase
          .from('news')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => NewsModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch recent news: $e');
    }
  }
}
