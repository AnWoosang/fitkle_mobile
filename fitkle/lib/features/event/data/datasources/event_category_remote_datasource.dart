import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/features/event/data/models/event_category_model.dart';

abstract class EventCategoryRemoteDataSource {
  Future<List<EventCategoryModel>> getCategories();
}

class EventCategoryRemoteDataSourceImpl implements EventCategoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  EventCategoryRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<EventCategoryModel>> getCategories() async {
    final response = await supabaseClient
        .from('event_categories')
        .select()
        .eq('is_active', true)
        .order('sort_order');

    return (response as List)
        .map((json) => EventCategoryModel.fromJson(json))
        .toList();
  }
}
