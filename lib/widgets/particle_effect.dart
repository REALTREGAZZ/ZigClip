import 'dart:math';
import 'package:flutter/material.dart';

class ParticleEffect extends StatefulWidget {
  final bool show;

  const ParticleEffect({
    super.key,
    required this.show,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _particles = _generateParticles();
    
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(ParticleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _particles = _generateParticles();
      _controller.forward(from: 0.0);
    }
  }

  List<Particle> _generateParticles() {
    final random = Random();
    return List.generate(8, (index) {
      final angle = (index / 8) * 2 * pi;
      return Particle(
        dx: cos(angle) * 100,
        dy: sin(angle) * 100,
        size: random.nextDouble() * 8 + 4,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();

    return CustomPaint(
      painter: ParticlePainter(
        particles: _particles,
        progress: _controller.value,
      ),
      size: const Size(200, 200),
    );
  }
}

class Particle {
  final double dx;
  final double dy;
  final double size;

  Particle({
    required this.dx,
    required this.dy,
    required this.size,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FFD0).withValues(alpha: 1.0 - progress)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final offset = Offset(
        center.dx + particle.dx * progress,
        center.dy + particle.dy * progress,
      );
      canvas.drawCircle(offset, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
