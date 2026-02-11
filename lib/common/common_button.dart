import 'package:flutter/material.dart';

/// Common press-scale effect for all buttons
class CommonScaleButton extends StatefulWidget {
  const CommonScaleButton({
    required this.child,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.scaleDown = 0.96,
    this.duration = const Duration(milliseconds: 120),
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final VoidCallback? onTapCancel;
  final double scaleDown;
  final Duration duration;

  @override
  State<CommonScaleButton> createState() => _CommonScaleButtonState();
}

class _CommonScaleButtonState extends State<CommonScaleButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _setPressed(true);
        widget.onTapDown?.call(details);
      },
      onTapUp: (details) {
        _setPressed(false);
        widget.onTapUp?.call(details);
      },
      onTapCancel: () {
        _setPressed(false);
        widget.onTapCancel?.call();
      },
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? widget.scaleDown : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
