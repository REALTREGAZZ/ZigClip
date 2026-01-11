import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EloDeltaAnimation extends StatelessWidget {
  final int delta;
  final bool show;

  const EloDeltaAnimation({
    super.key,
    required this.delta,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    final isPositive = delta > 0;
    final color = isPositive ? const Color(0xFF39FF14) : const Color(0xFFFF3B3B);
    final sign = isPositive ? '+' : '';

    return Text(
      '$sign$delta ELO',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: color,
        fontFamily: 'monospace',
        shadows: [
          Shadow(
            color: color.withValues(alpha: 0.8),
            blurRadius: 20,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 200.ms)
        .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0))
        .then(delay: 800.ms)
        .fadeOut(duration: 300.ms);
  }
}
