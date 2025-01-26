import 'package:supabase_flutter/supabase_flutter.dart';

class Authservise {
  final SupabaseClient supabase = Supabase.instance.client;

  /*Future<AuthResponse> emailpass(String email, String password) async {
    return await supabase.auth
        .signInWithPassword(email: email, password: password);
  }*/

  Future<void> emailpass(String email, String password) async {
    try {
      // Query the `usersnames` table for the entered email
      final response = await supabase
          .from('newwayusers')
          .select()
          .eq('emails', email.toLowerCase())
          .maybeSingle();

      if (response != null) {
        // Compare the entered password with the stored hashed password
        final storedPassword = response['password'] as String;
        final isPasswordValid = await _verifyPassword(password, storedPassword);

        if (isPasswordValid) {
          // Credentials are valid, take action (e.g., navigate to home page)
          print('Login successful');
        } else {
          throw 'Invalid password';
        }
      } else {
        throw 'User not found';
      }
    } catch (e) {
      throw 'Error: $e';
    }
  }

  Future<bool> _verifyPassword(
      String enteredPassword, String storedPassword) async {
    // Implement password verification logic here
    // For example, use `bcrypt` to compare hashed passwords
    return enteredPassword == storedPassword; // Replace with secure comparison
  }
}
