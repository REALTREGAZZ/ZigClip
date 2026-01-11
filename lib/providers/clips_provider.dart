import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/clip.dart';
import '../services/local_storage_service.dart';
import '../config/app_config.dart';

class ClipsNotifier extends StateNotifier<List<Clip>> {
  ClipsNotifier() : super([]) {
    _loadClips();
  }

  Future<void> _loadClips() async {
    final storage = await LocalStorageService.getInstance();
    final clips = await storage.loadClips();
    state = clips;
    AppConfig.log('Loaded ${clips.length} clips');
  }

  Future<void> updateClip(Clip clip) async {
    state = [
      for (final c in state)
        if (c.id == clip.id) clip else c,
    ];
    
    final storage = await LocalStorageService.getInstance();
    await storage.saveClip(clip);
    AppConfig.log('Updated clip: ${clip.id}');
  }

  Future<void> updateMultipleClips(List<Clip> updatedClips) async {
    final clips = [...state];
    for (final updated in updatedClips) {
      final index = clips.indexWhere((c) => c.id == updated.id);
      if (index != -1) {
        clips[index] = updated;
      }
    }
    state = clips;
    final storage = await LocalStorageService.getInstance();
    await storage.saveClips(clips);
  }

  Clip? getClipById(String id) {
    try {
      return state.firstWhere((clip) => clip.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> reload() async {
    await _loadClips();
  }
}

final clipsProvider = StateNotifierProvider<ClipsNotifier, List<Clip>>((ref) {
  return ClipsNotifier();
});
