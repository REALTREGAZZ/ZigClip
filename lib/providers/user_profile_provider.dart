import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile.dart';
import '../services/local_storage_service.dart';
import '../config/app_config.dart';

class ProfileNotifier extends StateNotifier<Profile> {
  ProfileNotifier() : super(Profile.initial()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final storage = await LocalStorageService.getInstance();
    final profile = await storage.loadUserProfile();
    state = profile;
    AppConfig.log('Loaded profile: ${profile.username}');
  }

  Future<void> updateProfile(Profile profile) async {
    state = profile;
    final storage = await LocalStorageService.getInstance();
    await storage.saveUserProfile(profile);
    AppConfig.log('Updated profile: ${profile.username}');
  }

  Future<void> incrementDuels() async {
    final updated = state.copyWith(
      duelsCompleted: state.duelsCompleted + 1,
    );
    await updateProfile(updated);
  }

  Future<void> updateRank(int rank) async {
    final updated = state.copyWith(rank: rank);
    await updateProfile(updated);
  }

  Future<void> reload() async {
    await _loadProfile();
  }
}

final userProfileProvider = StateNotifierProvider<ProfileNotifier, Profile>((ref) {
  return ProfileNotifier();
});
