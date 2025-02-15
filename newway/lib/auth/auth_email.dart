import 'package:supabase_flutter/supabase_flutter.dart';

class Authservise {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> emailpass(String email, String password) async {
    try {
      // Query the `newwayusers` table for the entered email
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

  Future<void> emailpassSignUp(String email, String password) async {
    try {
      // Check if the email already exists in the `newwayusers` table
      final existingUser = await supabase
          .from('newwayusers')
          .select()
          .eq('emails', email.toLowerCase())
          .maybeSingle();

      if (existingUser != null) {
        throw 'Email already in use';
      }

      // Hash the password before storing it (for security)
      final hashedPassword = await _hashPassword(password);

      // Insert the new user into the `newwayusers` table
      await supabase.from('newwayusers').insert({
        'emails': email.toLowerCase(),
        'password': hashedPassword,
      });

      print('Sign-up successful');
    } catch (e) {
      throw 'Error: $e';
    }
  }

  // Helper method to hash passwords
  Future<String> _hashPassword(String password) async {
    // For now, return the password as-is (replace with secure hashing in production)
    return password;
  }

  // Helper method to verify passwords
  Future<bool> _verifyPassword(
      String enteredPassword, String storedPassword) async {
    // For now, compare passwords directly (replace with secure comparison in production)
    return enteredPassword == storedPassword;
  }
}
