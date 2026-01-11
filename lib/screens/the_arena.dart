import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/arena_state_provider.dart';
import '../providers/clips_provider.dart';
import '../services/video_preloading_service.dart';
import '../services/audio_service.dart';
import '../widgets/arena_video_pair.dart';
import '../config/theme.dart';

class TheArena extends ConsumerStatefulWidget {
  const TheArena({super.key});

  @override
  ConsumerState<TheArena> createState() => _TheArenaState();
}

class _TheArenaState extends ConsumerState<TheArena> {
  final VideoPreloadingService _videoService = VideoPreloadingService();
  final AudioService _audioService = AudioService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _audioService.initialize();
    
    final clips = ref.read(clipsProvider);
    if (clips.isNotEmpty) {
      await _videoService.initialize(clips);
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoService.dispose();
    super.dispose();
  }

  Future<void> _handleWinnerSelected(String winnerId) async {
    await _audioService.playVictoryFeedback();
    
    await ref.read(arenaStateProvider.notifier).recordWinner(winnerId);
    
    await Future.delayed(const Duration(milliseconds: 1500));
    
    await _videoService.advanceToNext();
    await ref.read(arenaStateProvider.notifier).nextDuel();
  }

  @override
  Widget build(BuildContext context) {
    final arenaState = ref.watch(arenaStateProvider);

    if (!_isInitialized || arenaState == null) {
      return Scaffold(
        backgroundColor: bgDark,
        body: const Center(
          child: CircularProgressIndicator(
            color: neonCyan,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'DUEL #${arenaState.duelNumber}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: neonCyan,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: neonCyan),
            onPressed: () {
              _showInstructions(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ArenaVideoPair(
          leftClip: arenaState.current,
          rightClip: arenaState.next,
          leftController: _videoService.getCurrentController(),
          rightController: _videoService.getNextController(),
          onWinnerSelected: _handleWinnerSelected,
        ),
      ),
    );
  }

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: neonCyan, width: 2),
        ),
        title: const Text(
          'HOW TO PLAY',
          style: TextStyle(
            color: neonCyan,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Watch both clips',
              style: TextStyle(color: textElite, fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              '2. Swipe UP on the better clip',
              style: TextStyle(color: textElite, fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              '3. ELO points are calculated',
              style: TextStyle(color: textElite, fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              '4. Next duel automatically loads',
              style: TextStyle(color: textElite, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'GOT IT',
              style: TextStyle(
                color: neonCyan,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
