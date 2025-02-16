import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUpload {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch all users and their images
  Future<List<Map<String, dynamic>>> fetchUsersWithImages() async {
    final response = await _supabase
        .from('newwayfunnelinfo')
        .select('*, newwayfunnelinfoimage (imageurl, created_at)');

    // ignore: unnecessary_null_comparison
    if (response == null) {
      throw Exception('Error fetching data');
    }

    return List<Map<String, dynamic>>.from(response);
  }
}
