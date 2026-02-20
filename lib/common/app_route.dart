import 'package:flutter/material.dart';

Route<T> playfulRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final slide =
          Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
              .animate(fade);
      final scale = Tween<double>(begin: 0.98, end: 1.0).animate(fade);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: ScaleTransition(scale: scale, child: child),
        ),
      );
    },
  );
}
