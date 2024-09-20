import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:supabase_lab/model/user_model.dart';

class SupabaseService {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<String> fetchData() async {
    var data = await supabaseClient.from('demo').select().eq('id', 1);
    return ('Data: $data');
  }

  Future<String> register(
      String email, String password, String username, String role) async {
    try {
      await supabaseClient.from('users').insert({
        'email': email,
        'password': password, // Consider hashing passwords
        'username': username,
        'role': role
      });
      return 'SUCCESS';
    } catch (e) {
      return 'User already exist';
    }
  }

  Future<FusionUser> login(String username, String password) async {
    try {
      final res = await supabaseClient
          .from('users')
          .select() // Assuming you store email for Supabase authentication
          .eq('username', username)
          .eq('password', password)
          .single();
      FusionUser fusionUser = FusionUser.fromJson(res);
      return fusionUser;
    } catch (e) {
      return FusionUser();
    }
  }
}
