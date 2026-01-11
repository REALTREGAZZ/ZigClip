import 'package:flutter/material.dart';
import '../config/theme.dart';

class RankBadge extends StatelessWidget {
  final String badge;
  final double size;

  const RankBadge({
    super.key,
    required this.badge,
    this.size = 24,
  });

  Color get badgeColor {
    switch (badge) {
      case 'APEX':
        return goldBadge;
      case 'ELITE':
        return silverBadge;
      case 'VETERAN':
        return bronzeBadge;
      default:
        return textElite;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (badge.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size * 0.5, vertical: size * 0.25),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        border: Border.all(
          color: badgeColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Text(
        badge,
        style: TextStyle(
          fontSize: size * 0.6,
          fontWeight: FontWeight.bold,
          color: badgeColor,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
