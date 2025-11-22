import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/features/tag/data/models/tag_model.dart';

abstract class TagRemoteDataSource {
  Future<List<TagModel>> getTags();
}

class TagRemoteDataSourceImpl implements TagRemoteDataSource {
  final SupabaseClient supabaseClient;

  TagRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<TagModel>> getTags() async {
    final response = await supabaseClient
        .from('tags')
        .select()
        .eq('is_active', true)
        .order('name');

    return (response as List).map((json) => TagModel.fromJson(json)).toList();
  }
}
