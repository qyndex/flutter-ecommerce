import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton access to the Supabase client.
///
/// Call [SupabaseConfig.initialize] once in main() before runApp().
/// Then use [supabase] anywhere to access the client.
class SupabaseConfig {
  SupabaseConfig._();

  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}

/// Shorthand for the global Supabase client instance.
SupabaseClient get supabase => Supabase.instance.client;
