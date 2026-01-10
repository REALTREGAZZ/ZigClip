import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/clip_model.dart';
import '../config/constants.dart';

class VideoPreloadingService {
  VideoPlayerController? _currentController;
  VideoPlayerController? _nextController;
  
  int _currentIndex = 0;
  List<Clip> _clips = [];

  VideoPlayerController? get currentController => _currentController;
  VideoPlayerController? get nextController => _nextController;
  int get currentIndex => _currentIndex;

  Future<void> initialize(List<Clip> clips, int startIndex) async {
    _clips = clips;
    _currentIndex = startIndex;

    if (_clips.isEmpty) return;

    await _loadController(startIndex, isNext: false);
    
    if (startIndex + 1 < _clips.length) {
      await _loadController(startIndex + 1, isNext: true);
    }
  }

  Future<void> preloadNextClips(List<Clip> clips, int currentIndex) async {
    _clips = clips;
    _currentIndex = currentIndex;

    final nextIndex = currentIndex + 1;
    final preloadIndex = currentIndex + AppConstants.videoPreloadCount;

    if (nextIndex < _clips.length && _nextController == null) {
      await _loadController(nextIndex, isNext: true);
    }

    if (preloadIndex < _clips.length) {
      _preloadInBackground(preloadIndex);
    }
  }

  Future<void> swapControllers() async {
    final oldCurrent = _currentController;
    
    _currentController = _nextController;
    _nextController = null;
    
    _currentIndex++;

    await oldCurrent?.dispose();

    final nextIndex = _currentIndex + 1;
    if (nextIndex < _clips.length) {
      await _loadController(nextIndex, isNext: true);
    }

    final preloadIndex = _currentIndex + AppConstants.videoPreloadCount;
    if (preloadIndex < _clips.length) {
      _preloadInBackground(preloadIndex);
    }
  }

  Future<void> _loadController(int index, {required bool isNext}) async {
    if (index >= _clips.length) return;

    final clip = _clips[index];
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(clip.videoUrl),
    );

    try {
      await controller.initialize();
      controller.setLooping(true);
      
      if (isNext) {
        _nextController = controller;
      } else {
        _currentController = controller;
        await _currentController?.play();
      }
    } catch (e) {
      debugPrint('Failed to load video at index $index: $e');
    }
  }

  void _preloadInBackground(int index) {
    if (index >= _clips.length) return;

    final clip = _clips[index];
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(clip.videoUrl),
    );

    controller.initialize().then((_) {
      controller.dispose();
    }).catchError((e) {
      debugPrint('Background preload failed for index $index: $e');
    });
  }

  Future<void> pauseCurrent() async {
    await _currentController?.pause();
  }

  Future<void> resumeCurrent() async {
    await _currentController?.play();
  }

  void dispose() {
    _currentController?.dispose();
    _nextController?.dispose();
    _currentController = null;
    _nextController = null;
  }
}
