import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseClient(
    'https://nlodarcckrlkssfomqqf.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5sb2RhcmNja3Jsa3NzZm9tcXFmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM4NDk3NzIsImV4cCI6MjA0OTQyNTc3Mn0.CVTpCiWM4dflNaqthDhZHybstEUwvEIcIq96WNzxWg4',
  );


  // Sign in method using Supabase Authentication
  Future<String?> signInWithSupabase(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // If Supabase sign-in is successful, return success message
        return 'Sign-in successful!';
      } else {
        return 'Failed to sign in with Supabase.';
      }
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        return 'Invalid email or password.';
      } else {
        return 'Failed to sign in: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred: ${e.toString()}';
    }
  }

  // Sign-up method using Supabase Authentication
  Future<String> signUpWithSupabase(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return 'Sign-up successful!'; // Return success message
      } else {
        return 'Failed to sign up with Supabase.';
      }
    } on AuthException catch (e) {
      if (e.message.contains('User already registered')) {
        return 'Email is already in use.';
      } else if (e.message.contains('Password should be at least')) {
        return 'The password is too weak.';
      } else {
        return 'Failed to sign up: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred: ${e.toString()}';
    }
  }

  // Method to sign out the user
  Future<String> signOut() async {
    try {
      await _supabase.auth.signOut();
      return 'Sign-out successful!';
    } catch (e) {
      return 'An error occurred while signing out: ${e.toString()}';
    }
  }

  // Method to reset password
  Future<String> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return 'Password reset email sent.';
    } catch (e) {
      return 'An error occurred: ${e.toString()}';
    }
  }

  // Method to check if a user is logged in
  Future<String?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        return 'Logged in as: ${user.email}';
      } else {
        return 'No user is logged in.';
      }
    } catch (e) {
      return 'An error occurred: ${e.toString()}';
    }
  }
}

