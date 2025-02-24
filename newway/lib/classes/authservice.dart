import 'package:supabase_flutter/supabase_flutter.dart';

class Authservicelog {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signinemailpass(String email, String password) async {
    return await _supabase.auth
        .signInWithPassword(password: password, email: email);
  }

  Future<AuthResponse> signupemailpass(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signUp(password: password, email: email);
  }

  String? getuserid() {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print('No user logged in');
      return null;
    }
    return user.id;
  }

  Future<void> signout() async {
    await _supabase.auth.signOut();
  }

  String? getuseremail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
