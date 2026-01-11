import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/clip.dart';
import '../models/profile.dart';
import '../models/vote.dart';
import '../config/constants.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  SharedPreferences? _prefs;

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Clip>> loadClips() async {
    try {
      final String? clipsJson = _prefs?.getString(clipsStorageKey);
      if (clipsJson == null) {
        return _getInitialClips();
      }
      final List<dynamic> clipsList = json.decode(clipsJson);
      return clipsList.map((json) => Clip.fromJson(json)).toList();
    } catch (e) {
      return _getInitialClips();
    }
  }

  Future<void> saveClips(List<Clip> clips) async {
    final clipsJson = json.encode(clips.map((c) => c.toJson()).toList());
    await _prefs?.setString(clipsStorageKey, clipsJson);
  }

  Future<void> saveClip(Clip clip) async {
    final clips = await loadClips();
    final index = clips.indexWhere((c) => c.id == clip.id);
    if (index != -1) {
      clips[index] = clip;
    } else {
      clips.add(clip);
    }
    await saveClips(clips);
  }

  Future<Profile> loadUserProfile() async {
    try {
      final String? profileJson = _prefs?.getString(profileStorageKey);
      if (profileJson == null) {
        return Profile.initial();
      }
      return Profile.fromJson(json.decode(profileJson));
    } catch (e) {
      return Profile.initial();
    }
  }

  Future<void> saveUserProfile(Profile profile) async {
    final profileJson = json.encode(profile.toJson());
    await _prefs?.setString(profileStorageKey, profileJson);
  }

  Future<List<Vote>> loadVotes() async {
    try {
      final String? votesJson = _prefs?.getString(votesStorageKey);
      if (votesJson == null) {
        return [];
      }
      final List<dynamic> votesList = json.decode(votesJson);
      return votesList.map((json) => Vote.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveVote(Vote vote) async {
    final votes = await loadVotes();
    votes.add(vote);
    final votesJson = json.encode(votes.map((v) => v.toJson()).toList());
    await _prefs?.setString(votesStorageKey, votesJson);
  }

  List<Clip> _getInitialClips() {
    return [
      const Clip(
        id: 'clip_1',
        username: 'APEX_PRED_1',
        eloScore: 2450,
        videoPath: 'assets/videos/clip_1.mp4',
        wins: 87,
        losses: 23,
      ),
      const Clip(
        id: 'clip_2',
        username: 'ELITE_PLAYER_2',
        eloScore: 2100,
        videoPath: 'assets/videos/clip_2.mp4',
        wins: 65,
        losses: 35,
      ),
      const Clip(
        id: 'clip_3',
        username: 'VETERAN_GAMER_3',
        eloScore: 1850,
        videoPath: 'assets/videos/clip_3.mp4',
        wins: 52,
        losses: 48,
      ),
      const Clip(
        id: 'clip_4',
        username: 'RISING_STAR_4',
        eloScore: 1600,
        videoPath: 'assets/videos/clip_4.mp4',
        wins: 38,
        losses: 62,
      ),
      const Clip(
        id: 'clip_5',
        username: 'NEWBIE_GRINDER_5',
        eloScore: 1400,
        videoPath: 'assets/videos/clip_5.mp4',
        wins: 25,
        losses: 75,
      ),
    ];
  }

  Future<void> reset() async {
    await _prefs?.clear();
  }
}
