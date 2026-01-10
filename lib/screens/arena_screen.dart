import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../models/vote_model.dart';
import '../providers/clip_provider.dart';
import '../providers/elo_provider.dart';
import '../services/video_preloader.dart';
import '../services/elo_service.dart';
import '../services/supabase_service.dart';
import '../widgets/arena_card.dart';
import '../widgets/elo_feedback_widget.dart';

class ArenaScreen extends ConsumerStatefulWidget {
  const ArenaScreen({super.key});

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen>
    with SingleTickerProviderStateMixin {
  final VideoPreloadingService _preloader = VideoPreloadingService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  double _dragDistance = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAudio();
    _initializeArena();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  Future<void> _loadAudio() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/kill_sound.mp3');
    } catch (e) {
      debugPrint('Failed to load audio: $e');
    }
  }

  Future<void> _initializeArena() async {
    await ref.read(clipProvider.notifier).loadClips();
    final state = ref.read(clipProvider);
    
    if (state.clips.isNotEmpty) {
      await _preloader.initialize(state.clips, 0);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _preloader.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clipState = ref.watch(clipProvider);
    final eloState = ref.watch(eloProvider);

    if (clipState.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.neonCyan),
        ),
      );
    }

    if (clipState.clips.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(
          child: Text(
            'No clips available',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return ArenaCard(
                    controller: _preloader.currentController,
                    opacity: _opacityAnimation.value,
                    scale: _scaleAnimation.value,
                  );
                },
              ),
            ),
          ),
          if (eloState.isAnimating && eloState.lastEloGain != null)
            EloFeedbackWidget(feedback: eloState.lastEloGain),
          _buildHeader(clipState),
          _buildSwipeIndicator(),
        ],
      ),
    );
  }

  Widget _buildHeader(ClipState state) {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'THE ARENA',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.neonCyan,
                    shadows: [
                      Shadow(
                        color: AppColors.neonCyan,
                        blurRadius: 10,
                      ),
                    ],
                  ),
            ),
            Text(
              '${state.currentIndex + 1}/${state.clips.length}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeIndicator() {
    if (_dragDistance == 0) return const SizedBox.shrink();

    final isRight = _dragDistance > 0;
    final color = isRight ? AppColors.neonCyan : AppColors.neonRed;
    final label = isRight ? 'WIN' : 'LOSE';
    final opacity = (_dragDistance.abs() / AppConstants.swipeThreshold).clamp(0.0, 1.0);

    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: isRight ? Alignment.centerRight : Alignment.centerLeft,
              radius: 1.0,
              colors: [
                color.withValues(alpha: 0.3 * opacity),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontFamily: 'monospace',
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: color,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;

    setState(() {
      _dragDistance += details.delta.dx;
    });
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    if (_isAnimating) return;

    final threshold = AppConstants.swipeThreshold;
    
    if (_dragDistance.abs() >= threshold) {
      final isWinner = _dragDistance > 0;
      await _processVote(isWinner);
    }

    setState(() {
      _dragDistance = 0;
    });
  }

  Future<void> _processVote(bool currentClipWins) async {
    if (_isAnimating) return;
    
    _isAnimating = true;
    final clipState = ref.read(clipProvider);
    final currentClip = clipState.currentClip;
    final nextClip = clipState.nextClip;

    if (currentClip == null || nextClip == null) {
      _isAnimating = false;
      return;
    }

    final winnerClip = currentClipWins ? currentClip : nextClip;
    final loserClip = currentClipWins ? nextClip : currentClip;

    final eloResults = EloService.calculateNewRatings(
      winnerClip.eloScore,
      loserClip.eloScore,
    );

    final delta = eloResults['delta']!;

    ref.read(eloProvider.notifier).showEloChange(delta, currentClipWins);

    try {
      _playKillSound();
    } catch (e) {
      debugPrint('Failed to play sound: $e');
    }

    await _animationController.forward();

    ref.read(clipProvider.notifier).updateClipElo(
          winnerClip.id,
          eloResults['winnerNew']!,
        );
    ref.read(clipProvider.notifier).updateClipElo(
          loserClip.id,
          eloResults['loserNew']!,
        );

    final vote = Vote(
      winnerId: winnerClip.id,
      loserId: loserClip.id,
      eloDelta: delta,
    );

    await SupabaseService().submitVote(vote);

    await Future.delayed(const Duration(milliseconds: 300));

    ref.read(clipProvider.notifier).moveToNext();
    await _preloader.swapControllers();

    _animationController.reset();
    _isAnimating = false;

    final updatedState = ref.read(clipProvider);
    await _preloader.preloadNextClips(
      updatedState.clips,
      updatedState.currentIndex,
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _playKillSound() {
    try {
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.play();
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }
}
