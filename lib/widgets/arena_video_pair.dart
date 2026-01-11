import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_player_widget.dart';
import 'elo_delta_animation.dart';
import 'neon_flash_widget.dart';
import 'particle_effect.dart';
import '../models/clip.dart';

class ArenaVideoPair extends StatefulWidget {
  final Clip leftClip;
  final Clip rightClip;
  final VideoPlayerController? leftController;
  final VideoPlayerController? rightController;
  final Function(String winnerId) onWinnerSelected;

  const ArenaVideoPair({
    super.key,
    required this.leftClip,
    required this.rightClip,
    required this.leftController,
    required this.rightController,
    required this.onWinnerSelected,
  });

  @override
  State<ArenaVideoPair> createState() => _ArenaVideoPairState();
}

class _ArenaVideoPairState extends State<ArenaVideoPair> {
  String? _winnerId;
  bool _showLeftDelta = false;
  bool _showRightDelta = false;
  bool _showLeftFlash = false;
  bool _showRightFlash = false;
  bool _showLeftParticles = false;
  bool _showRightParticles = false;

  @override
  void didUpdateWidget(ArenaVideoPair oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leftClip.id != widget.leftClip.id ||
        oldWidget.rightClip.id != widget.rightClip.id) {
      setState(() {
        _winnerId = null;
        _showLeftDelta = false;
        _showRightDelta = false;
        _showLeftFlash = false;
        _showRightFlash = false;
        _showLeftParticles = false;
        _showRightParticles = false;
      });
    }
  }

  void _handleSwipeUp(bool isLeft) {
    if (_winnerId != null) return;

    final winnerId = isLeft ? widget.leftClip.id : widget.rightClip.id;
    setState(() {
      _winnerId = winnerId;
      if (isLeft) {
        _showLeftFlash = true;
        _showLeftDelta = true;
        _showLeftParticles = true;
      } else {
        _showRightFlash = true;
        _showRightDelta = true;
        _showRightParticles = true;
      }
    });

    widget.onWinnerSelected(winnerId);
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return isPortrait ? _buildPortraitLayout() : _buildLandscapeLayout();
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(child: _buildLeftVideo()),
        Expanded(child: _buildRightVideo()),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        Expanded(child: _buildLeftVideo()),
        Expanded(child: _buildRightVideo()),
      ],
    );
  }

  Widget _buildLeftVideo() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < -500) {
          _handleSwipeUp(true);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          NeonFlashWidget(
            trigger: _showLeftFlash,
            child: VideoPlayerWidget(
              controller: widget.leftController,
              isActive: _winnerId == null || _winnerId == widget.leftClip.id,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: EloDeltaAnimation(
                delta: widget.leftClip.eloScore,
                show: _showLeftDelta,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: ParticleEffect(show: _showLeftParticles),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: _buildClipInfo(widget.leftClip),
          ),
        ],
      ),
    );
  }

  Widget _buildRightVideo() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < -500) {
          _handleSwipeUp(false);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          NeonFlashWidget(
            trigger: _showRightFlash,
            child: VideoPlayerWidget(
              controller: widget.rightController,
              isActive: _winnerId == null || _winnerId == widget.rightClip.id,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: EloDeltaAnimation(
                delta: widget.rightClip.eloScore,
                show: _showRightDelta,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: ParticleEffect(show: _showRightParticles),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildClipInfo(widget.rightClip),
          ),
        ],
      ),
    );
  }

  Widget _buildClipInfo(Clip clip) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF00FFD0).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            clip.username,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FFD0),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${clip.eloScore} ELO',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFB0B0B0),
            ),
          ),
        ],
      ),
    );
  }
}
