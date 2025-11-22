import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/features/group/data/models/group_category_model.dart';

abstract class GroupCategoryRemoteDataSource {
  Future<List<GroupCategoryModel>> getCategories();
}

class GroupCategoryRemoteDataSourceImpl implements GroupCategoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  GroupCategoryRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<GroupCategoryModel>> getCategories() async {
    final response = await supabaseClient
        .from('group_categories')
        .select()
        .eq('is_active', true)
        .order('sort_order');

    return (response as List)
        .map((json) => GroupCategoryModel.fromJson(json))
        .toList();
  }
}
