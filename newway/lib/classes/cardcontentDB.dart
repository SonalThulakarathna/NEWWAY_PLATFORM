import 'package:newway/classes/card_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cardcontentdb {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch data from Supabase
  Future<List<Cardcontent>> getCardContents() async {
    try {
      // Fetch all columns from newwayfunnelinfo
      final response = await _supabase
          .from('newwayfunnelinfo')
          .select('*')
          .order('created_at', ascending: false); // Sort by newest first

      if (response.isEmpty) {
        print(" No data found in newwayfunnelinfo table");
        return [];
      }

      print(" Fetched ${response.length} records");

      // Map response to Cardcontent objects
      return response.map((item) {
        print(" Processing item: ${item['id']}");

        return Cardcontent(
          title: item['salutation']?.toString() ?? 'No Salutation',
          subtitle: item['summaray']?.toString() ?? 'No Summary',
          author: item['name']?.toString() ?? 'Anonymous',
          condition: item['condition']?.toString() ?? 'public',
          imagepath: item['imagepath']?.toString() ?? 'lib/images/default.jpg',
          members: item['members']?.toString() ?? '0',
          price: item['price']?.toString() ?? '0',
          id: int.tryParse(item['id'].toString()) ?? 0,
          funnelownerid: int.tryParse(item['userid'].toString()) ?? 0,
          userimageurl:
              item['funnelimageurl']?.toString() ?? 'lib/images/default.jpg',
        );
      }).toList();
    } catch (e) {
      print(" Error fetching data: ${e.toString()}");
      return [];
    }
  }
}
