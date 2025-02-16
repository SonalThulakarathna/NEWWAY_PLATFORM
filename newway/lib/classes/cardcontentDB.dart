import 'package:newway/classes/card_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cardcontentdb {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch data from Supabase
  Future<List<Cardcontent>> getCardContents() async {
    try {
      final response = await _supabase.from('newwayfunnelinfo').select('''
          *, 
          newwayfunnelinfoimage!newwayfunnelinfo_userimageid_fkey (imageurl)  // Explicit join
        ''');

      print("✅ Supabase Response: $response"); // Debugging print

      // ignore: unnecessary_null_comparison
      if (response == null || response.isEmpty) {
        print("🚨 No data found from Supabase!");
        return [];
      }

      return response.map((item) {
        final userImages =
            item['newwayfunnelinfoimage'] as List<dynamic>? ?? [];
        final userImageUrl = userImages.isNotEmpty
            ? userImages[0]['imageurl']
            : 'lib/images/anime.jpg'; // Fallback to a default image URL if null

        print("🖼 Image URL: $userImageUrl"); // Debugging print

        return Cardcontent(
          title: item['salutation'] ?? '',
          subtitle: item['summaray'] ?? '',
          author: item['name'] ?? '',
          condition: item['condition'] ?? '',
          imagepath: item['imagepath'] ?? '',
          members: item['members']?.toString() ?? '0',
          price: item['price']?.toString() ?? '0',
          userimageid: item['userimageid'] is int
              ? item['userimageid']
              : int.tryParse(item['userimageid'].toString()) ?? 0,
          userimageurl:
              userImageUrl, // Use the fallback URL if no image is found
        );
      }).toList();
    } catch (e) {
      print("❌ Error fetching data: $e");
      return [];
    }
  }
}
