import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';

class SupabaseConfig {
  static SupabaseClient? _client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }
  
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase client not initialized. Call initialize() first.');
    }
    return _client!;
  }
  
  static Future<void> signInAnonymously() async {
    try {
      await client.auth.signInAnonymously();
    } catch (e) {
      throw Exception('Anonymous sign-in failed: $e');
    }
  }
  
  static Future<void> updateUsername(String username) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) throw Exception('No user logged in');
      
      await client.from('profiles').upsert({
        'id': userId,
        'username': username,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Username update failed: $e');
    }
  }
  
  static String? get currentUserId => client.auth.currentUser?.id;
  
  static bool get isAuthenticated => client.auth.currentUser != null;
}
