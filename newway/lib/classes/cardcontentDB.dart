import 'package:newway/classes/card_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cardcontentdb {
  final database = Supabase.instance.client.from('newwayfunnelinfo');

  Future createfunnel(Cardcontent newcc) async {
    await database.insert(newcc);
  }

  final stream = Supabase.instance.client
      .from('newwayfunnelinfo')
      .stream(primaryKey: ['id']);
}
