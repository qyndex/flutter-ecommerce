import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

part 'auth_provider.g.dart';

/// Provides the singleton [AuthService] instance.
@riverpod
AuthService authService(Ref ref) => const AuthService();

/// Watches the Supabase auth state and exposes the current [User?].
///
/// Returns null when signed out; non-null when signed in.
@riverpod
class Auth extends _$Auth {
  StreamSubscription<AuthState>? _sub;

  @override
  User? build() {
    final service = ref.read(authServiceProvider);
    _sub = service.authStateChanges.listen((authState) {
      state = authState.session?.user;
    });
    ref.onDispose(() => _sub?.cancel());
    return service.currentUser;
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final service = ref.read(authServiceProvider);
    final response = await service.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    state = response.user;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final service = ref.read(authServiceProvider);
    final response = await service.signIn(
      email: email,
      password: password,
    );
    state = response.user;
  }

  Future<void> signOut() async {
    final service = ref.read(authServiceProvider);
    await service.signOut();
    state = null;
  }
}
