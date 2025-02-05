import 'package:newway/classes/card_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cardcontentdb {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch data from Supabase
  Future<List<Cardcontent>> getCardContents() async {
    final response = await _supabase.from('newwayfunnelinfo').select();

    // ignore: unnecessary_type_check
    if (response is! List) {
      throw Exception('Unexpected response format from Supabase');
    }

    return response
        .map((item) => Cardcontent(
              title: item['salutation'] ?? '',
              subtitle: item['summaray'] ?? '',
              author: item['name'] ?? '',
              condition: item['condition'] ?? '',
              imagepath: item['imagepath'] ?? '',
              members: item['members'] ?? '',
              price: item['price'] ?? '',
            ))
        .toList();
  }
}
