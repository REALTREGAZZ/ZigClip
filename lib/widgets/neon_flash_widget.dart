import 'package:flutter/material.dart';

class NeonFlashWidget extends StatefulWidget {
  final bool trigger;
  final Widget child;

  const NeonFlashWidget({
    super.key,
    required this.trigger,
    required this.child,
  });

  @override
  State<NeonFlashWidget> createState() => _NeonFlashWidgetState();
}

class _NeonFlashWidgetState extends State<NeonFlashWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0.0, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(NeonFlashWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _controller.forward(from: 0.0).then((_) {
        _controller.reverse();
      });
    }
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
          foregroundDecoration: BoxDecoration(
            color: const Color(0xFF00FFD0).withValues(alpha: _animation.value),
          ),
          child: widget.child,
        );
      },
    );
  }
}
