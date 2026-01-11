import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/arena_state.dart';
import '../models/clip.dart';
import '../models/vote.dart';
import '../services/local_storage_service.dart';
import '../services/elo_service.dart';
import '../config/app_config.dart';
import 'clips_provider.dart';

class ArenaStateNotifier extends StateNotifier<ArenaState?> {
  final Ref ref;

  ArenaStateNotifier(this.ref) : super(null) {
    _initialize();
  }

  Future<void> _initialize() async {
    final clips = ref.read(clipsProvider);
    if (clips.length >= 2) {
      state = ArenaState.initial(clips);
      AppConfig.log('Arena initialized with ${clips.length} clips');
    }
  }

  Future<void> recordWinner(String winnerClipId) async {
    if (state == null) return;

    final currentState = state!;
    final winner = currentState.current.id == winnerClipId 
        ? currentState.current 
        : currentState.next;
    final loser = currentState.current.id == winnerClipId 
        ? currentState.next 
        : currentState.current;

    final result = EloService.calculateDuel(winner, loser);
    
    final (updatedWinner, updatedLoser) = EloService.applyDuelResult(winner, loser);

    final storage = await LocalStorageService.getInstance();
    await storage.saveVote(Vote(
      clip1Id: currentState.current.id,
      clip2Id: currentState.next.id,
      winnerId: winnerClipId,
      eloDelta: result.winnerDelta,
      timestamp: DateTime.now(),
    ));

    ref.read(clipsProvider.notifier).updateMultipleClips([
      updatedWinner,
      updatedLoser,
    ]);

    state = currentState.selectWinner(winnerClipId);
    
    AppConfig.log('Winner recorded: $winnerClipId (Δ${result.winnerDelta})');
  }

  Future<void> nextDuel() async {
    if (state == null) return;
    
    final clips = ref.read(clipsProvider);
    final currentState = state!;
    
    if (clips.length < 2) return;

    final currentClip = clips[currentState.duelNumber % clips.length];
    final nextClip = clips[(currentState.duelNumber + 1) % clips.length];
    final upcomingClips = clips.length > 2 
        ? clips.sublist(2) 
        : [];

    state = ArenaState(
      current: currentClip,
      next: nextClip,
      upcoming: upcomingClips,
      duelNumber: currentState.duelNumber + 1,
    );

    AppConfig.log('Advanced to duel #${state!.duelNumber}');
  }

  void reset() {
    _initialize();
  }
}

final arenaStateProvider = StateNotifierProvider<ArenaStateNotifier, ArenaState?>((ref) {
  return ArenaStateNotifier(ref);
});
