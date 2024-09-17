import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAPI {
  Future<String> fetchData() async {
    final supabase = Supabase.instance.client;
    var data = await supabase.from('demo').select().eq('id', 1);
    return ('Data: $data');
  }
}
