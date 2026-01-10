import 'package:flutter/material.dart';
import '../config/theme.dart';

class NeonaBadge extends StatelessWidget {
  final String badge;
  final double fontSize;

  const NeonaBadge({
    super.key,
    required this.badge,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getBadgeColor(badge);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        badge.toUpperCase(),
        style: TextStyle(
          color: color,
          fontFamily: 'monospace',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          shadows: [
            Shadow(
              color: color,
              blurRadius: 5,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBadgeColor(String badge) {
    if (badge.contains('Elite 1%')) {
      return const Color(0xFFFFD700);
    } else if (badge.contains('Top 5%')) {
      return AppColors.neonCyan;
    } else if (badge.contains('Top 10%')) {
      return const Color(0xFF9D4EDD);
    } else if (badge.contains('Rising Star')) {
      return const Color(0xFF06FFA5);
    } else {
      return AppColors.textElite;
    }
  }
}

class EloDisplay extends StatelessWidget {
  final int eloScore;
  final double fontSize;

  const EloDisplay({
    super.key,
    required this.eloScore,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ELO: ',
          style: TextStyle(
            color: AppColors.textElite,
            fontFamily: 'monospace',
            fontSize: fontSize * 0.8,
          ),
        ),
        Text(
          eloScore.toString(),
          style: TextStyle(
            color: AppColors.neonCyan,
            fontFamily: 'monospace',
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: AppColors.neonCyan,
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
