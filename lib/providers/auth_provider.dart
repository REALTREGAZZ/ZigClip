import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';
import '../services/supabase_service.dart';
import '../config/supabase_client.dart';
import 'clip_provider.dart';

class AuthState {
  final Profile? currentUser;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  AuthState({
    this.currentUser,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({
    Profile? currentUser,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SupabaseService _supabaseService;

  AuthNotifier(this._supabaseService) : super(AuthState());

  Future<void> signInAnonymously() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await SupabaseConfig.signInAnonymously();
      final profile = await _supabaseService.getUserProfile();
      
      state = state.copyWith(
        currentUser: profile,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateUsername(String username) async {
    try {
      await SupabaseConfig.updateUsername(username);
      
      if (state.currentUser != null) {
        state = state.copyWith(
          currentUser: state.currentUser!.copyWith(username: username),
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);

    try {
      final profile = await _supabaseService.getUserProfile();
      state = state.copyWith(
        currentUser: profile,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void signOut() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return AuthNotifier(supabaseService);
});
