import 'package:newway/classes/video_card_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoCarddb {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<VideoCardContent>> getvideoContents() async {
    try {
      final response = await _supabase.from('funnelvideodetails').select();

      if (response.isEmpty) {
        print("No data found in funnelvideodetails table");
        return [];
      }

      return response.map<VideoCardContent>((item) {
        return VideoCardContent(
          description: item['videodes']?.toString() ?? 'No Description',
          url: item['videourl']?.toString() ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching video contents: $e');
      return [];
    }
  }
}
