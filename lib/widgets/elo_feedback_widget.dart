import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';
import '../providers/elo_provider.dart';

class EloFeedbackWidget extends StatelessWidget {
  final EloFeedback? feedback;

  const EloFeedbackWidget({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    if (feedback == null) {
      return const SizedBox.shrink();
    }

    final color = feedback!.isWinner ? AppColors.neonCyan : AppColors.neonRed;

    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: color,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Text(
            feedback!.formattedDelta,
            style: TextStyle(
              color: color,
              fontFamily: 'monospace',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: color,
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 100.ms)
            .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0))
            .then(delay: 1200.ms)
            .fadeOut(duration: 200.ms),
      ),
    );
  }
}

class FlashEffect extends StatefulWidget {
  final Color color;
  final Widget child;

  const FlashEffect({
    super.key,
    required this.color,
    required this.child,
  });

  @override
  State<FlashEffect> createState() => _FlashEffectState();
}

class _FlashEffectState extends State<FlashEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.3 * (1 - _animation.value)),
          ),
          child: widget.child,
        );
      },
    );
  }
}
