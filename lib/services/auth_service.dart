import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

/// Wraps Supabase Auth for email/password sign-up, sign-in, and sign-out.
class AuthService {
  const AuthService();

  /// The currently signed-in user, or null.
  User? get currentUser => supabase.auth.currentUser;

  /// Whether a user is signed in.
  bool get isSignedIn => currentUser != null;

  /// Stream of auth state changes.
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  /// Sign up with email and password.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    return supabase.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );
  }

  /// Sign in with email and password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
