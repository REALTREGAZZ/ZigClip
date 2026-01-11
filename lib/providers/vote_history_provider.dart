import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vote.dart';
import '../services/local_storage_service.dart';
import '../config/app_config.dart';

class VoteHistoryNotifier extends StateNotifier<List<Vote>> {
  VoteHistoryNotifier() : super([]) {
    _loadVotes();
  }

  Future<void> _loadVotes() async {
    final storage = await LocalStorageService.getInstance();
    final votes = await storage.loadVotes();
    state = votes;
    AppConfig.log('Loaded ${votes.length} votes');
  }

  Future<void> addVote(Vote vote) async {
    state = [...state, vote];
    final storage = await LocalStorageService.getInstance();
    await storage.saveVote(vote);
    AppConfig.log('Added vote: ${vote.winnerId}');
  }

  Future<void> reload() async {
    await _loadVotes();
  }
}

final voteHistoryProvider = StateNotifierProvider<VoteHistoryNotifier, List<Vote>>((ref) {
  return VoteHistoryNotifier();
});
