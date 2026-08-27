import 'package:supabase_flutter/supabase_flutter.dart';

class LevelService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getLevelProgress() async{
    try{
      final user = _supabase.auth.currentUser;
      if(user == null) return [];
      final response = await _supabase .from('progress_level')
      .select('*')
      .eq('id', user.id);
      return List<Map<String, dynamic>>.from(response);
    } catch(e){
      print('Error fetching level progress: $e');
      return [];
    }
  }

  static Future<bool> saveLevelProgress({
    required int story_id,
    required int level_id,
    required int stars,
    bool is_completed = true,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;
      await _supabase.from('progress_level').upsert({
        'id': user.id,
        'story_id': story_id,
        'level_id' : level_id,
        'stars' : stars,
        'is_completed' : is_completed,
        'updated_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error saving level progress: $e');
      return false;
    }
  }
}
