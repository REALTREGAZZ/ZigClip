import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import 'video_player_widget.dart';

class ArenaCard extends StatefulWidget {
  final VideoPlayerController? controller;
  final double opacity;
  final double scale;
  final Widget? overlay;

  const ArenaCard({
    super.key,
    required this.controller,
    this.opacity = 1.0,
    this.scale = 1.0,
    this.overlay,
  });

  @override
  State<ArenaCard> createState() => _ArenaCardState();
}

class _ArenaCardState extends State<ArenaCard> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale,
      child: Opacity(
        opacity: widget.opacity,
        child: Container(
          width: AppConstants.arenaCardWidth,
          height: AppConstants.arenaCardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                VideoPlayerWidget(controller: widget.controller),
                if (widget.overlay != null)
                  Positioned.fill(
                    child: widget.overlay!,
                  ),
                _buildGlassOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.glassBg,
                ],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSwipeHint(Icons.arrow_back, 'LOSE', AppColors.neonRed),
                _buildSwipeHint(Icons.arrow_forward, 'WIN', AppColors.neonCyan),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeHint(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color.withValues(alpha: 0.6), size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color.withValues(alpha: 0.6),
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
