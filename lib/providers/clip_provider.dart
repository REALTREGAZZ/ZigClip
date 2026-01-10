import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/clip_model.dart';
import '../services/supabase_service.dart';

class ClipState {
  final List<Clip> clips;
  final int currentIndex;
  final bool isLoading;
  final String? error;

  ClipState({
    this.clips = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.error,
  });

  ClipState copyWith({
    List<Clip>? clips,
    int? currentIndex,
    bool? isLoading,
    String? error,
  }) {
    return ClipState(
      clips: clips ?? this.clips,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  Clip? get currentClip =>
      currentIndex < clips.length ? clips[currentIndex] : null;

  Clip? get nextClip =>
      currentIndex + 1 < clips.length ? clips[currentIndex + 1] : null;

  int get nextClipIndex => currentIndex + 1;
}

class ClipNotifier extends StateNotifier<ClipState> {
  final SupabaseService _supabaseService;

  ClipNotifier(this._supabaseService) : super(ClipState());

  Future<void> loadClips() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final clips = await _supabaseService.fetchClipsForArena();
      state = state.copyWith(
        clips: clips,
        currentIndex: 0,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void moveToNext() {
    if (state.currentIndex + 1 < state.clips.length) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void updateClipElo(String clipId, int newElo) {
    final updatedClips = state.clips.map((clip) {
      if (clip.id == clipId) {
        return clip.copyWith(eloScore: newElo);
      }
      return clip;
    }).toList();

    state = state.copyWith(clips: updatedClips);
  }

  void reset() {
    state = ClipState();
  }
}

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final clipProvider = StateNotifierProvider<ClipNotifier, ClipState>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return ClipNotifier(supabaseService);
});
