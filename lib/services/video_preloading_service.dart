import 'package:video_player/video_player.dart';
import '../models/clip.dart';
import '../config/app_config.dart';

class VideoPreloadingService {
  VideoPlayerController? _currentController;
  VideoPlayerController? _nextController;
  VideoPlayerController? _upcomingController;

  int _currentIndex = 0;
  List<Clip> _clips = [];

  bool get isInitialized => _currentController != null && _nextController != null;

  Future<void> initialize(List<Clip> clips) async {
    if (clips.length < 2) {
      throw Exception('Need at least 2 clips for video preloading');
    }

    _clips = clips;
    _currentIndex = 0;

    await _disposeControllers();

    _currentController = VideoPlayerController.asset(_clips[0].videoPath);
    await _currentController!.initialize();
    await _currentController!.setLooping(true);
    await _currentController!.play();

    _nextController = VideoPlayerController.asset(_clips[1].videoPath);
    await _nextController!.initialize();
    await _nextController!.setLooping(true);

    if (_clips.length > 2) {
      _upcomingController = VideoPlayerController.asset(_clips[2].videoPath);
      _upcomingController!.initialize();
    }

    AppConfig.log('VideoPreloadingService initialized with ${clips.length} clips');
  }

  VideoPlayerController? getCurrentController() => _currentController;
  VideoPlayerController? getNextController() => _nextController;

  Future<void> advanceToNext() async {
    if (!isInitialized) return;

    _currentIndex = (_currentIndex + 1) % _clips.length;
    final nextIndex = (_currentIndex + 1) % _clips.length;
    final upcomingIndex = (_currentIndex + 2) % _clips.length;

    final oldCurrent = _currentController;
    _currentController = _nextController;
    _nextController = _upcomingController;

    await oldCurrent?.pause();
    await _currentController?.play();

    if (_clips.length > 2) {
      _upcomingController = VideoPlayerController.asset(_clips[upcomingIndex].videoPath);
      await _upcomingController?.initialize();
      await _upcomingController?.setLooping(true);
    } else {
      _upcomingController = oldCurrent;
      await _upcomingController?.seekTo(Duration.zero);
    }

    oldCurrent?.dispose();

    AppConfig.log('Advanced to clip #$_currentIndex');
  }

  Future<void> _disposeControllers() async {
    await _currentController?.dispose();
    await _nextController?.dispose();
    await _upcomingController?.dispose();
    _currentController = null;
    _nextController = null;
    _upcomingController = null;
  }

  void dispose() {
    _disposeControllers();
  }

  int get currentIndex => _currentIndex;
  int get nextIndex => (_currentIndex + 1) % _clips.length;
}
