import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/theme.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.borderRadius = 12,
    this.borderColor = neonCyan,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: glassWhite,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor.withValues(alpha: 0.3),
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
