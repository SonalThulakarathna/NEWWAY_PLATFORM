import 'package:newway/classes/userdata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Userdatadb {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Userdata?> getFunnelId() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      print("No user is logged in.");
      return null;
    }

    final response = await _supabase
        .from('newwayusers')
        .select('funnelidnum')
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      print("User not found in newwayusers table.");
      return null;
    }

    // Ensure funnelidnum is an int
    final funnelid = response['funnelidnum'] as int?;
    return funnelid != null ? Userdata(funnelid: funnelid) : null;
  }
}
