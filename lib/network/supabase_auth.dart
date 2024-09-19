import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<void> signUp(
      String email, String password, String username, String role) async {
    final AuthResponse res =
        await supabaseClient.auth.signUp(password: password, email: email);

    if (res.user != null) {
      // Insert user details into your custom table
      await supabaseClient.from('users').insert({
        'id': res.user!.id,
        'email': email,
        'password': password, // Consider hashing passwords
        'username': username,
        'role': role
      });
    } else {
      throw Exception(const AuthException('Insert Problem'));
    }
  }

  Future<String?> signInWithUsername(String username, String password) async {
    // Check if the username exists in the custom users table
    final res = await supabaseClient
        .from('users')
        .select('email') // Assuming you store email for Supabase authentication
        .eq('username', username)
        .eq('password', password);

    if (res.isNotEmpty) {
      var data = res.single;
      var email = data['email'];

      final AuthResponse response =
          await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      //final User? user = response.user;
      final Session? session = response.session;
      return session?.accessToken;
    } else {
      throw Exception("Username not found");
    }
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
