import 'dart:math' as math;

import 'package:flutter/material.dart';

class CelebrationOverlay extends StatefulWidget {
  const CelebrationOverlay({required this.trigger, super.key});

  final int trigger;

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    if (widget.trigger > 0) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger && widget.trigger > 0) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.value <= 0 || _controller.value >= 1) {
            return const SizedBox.shrink();
          }

          return Stack(
            children: List<Widget>.generate(16, (index) {
              final angle = (math.pi * 2 / 16) * index;
              final travel = Curves.easeOut.transform(_controller.value) * 120;
              final dx = math.cos(angle) * travel;
              final dy = math.sin(angle) * travel;
              final opacity = (1 - _controller.value).clamp(0.0, 1.0);

              return Align(
                alignment: const Alignment(0, 0.32),
                child: Transform.translate(
                  offset: Offset(dx, dy),
                  child: Opacity(
                    opacity: opacity,
                    child: Icon(
                      index.isEven ? Icons.star_rounded : Icons.circle,
                      size: index.isEven ? 16 : 9,
                      color: index % 3 == 0
                          ? const Color(0xFFFFD84D)
                          : index % 3 == 1
                              ? const Color(0xFFFF8AA8)
                              : const Color(0xFF7AD6FF),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
