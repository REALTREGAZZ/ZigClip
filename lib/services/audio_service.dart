import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import '../config/constants.dart';
import '../config/app_config.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _killSoundPlayer = AudioPlayer();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await _killSoundPlayer.setAsset(killSoundPath);
      _initialized = true;
      AppConfig.log('AudioService initialized');
    } catch (e) {
      AppConfig.log('Failed to initialize audio: $e');
    }
  }

  Future<void> playKillSound() async {
    if (!_initialized) {
      await initialize();
    }
    
    try {
      await _killSoundPlayer.seek(Duration.zero);
      await _killSoundPlayer.play();
    } catch (e) {
      AppConfig.log('Failed to play kill sound: $e');
    }
  }

  Future<void> playHaptic() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      AppConfig.log('Failed to play haptic: $e');
    }
  }

  Future<void> playVictoryFeedback() async {
    await Future.wait([
      playKillSound(),
      playHaptic(),
    ]);
  }

  void dispose() {
    _killSoundPlayer.dispose();
  }
}
