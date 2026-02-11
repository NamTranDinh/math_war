import 'dart:ui';
import 'package:flutter/material.dart';
import '../common/common_button.dart';

/// Frosted glass card effect using BackdropFilter
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.borderRadius = 20,
    this.blur = 10,
    this.opacity = 0.2,
    this.borderOpacity = 0.2,
    this.padding,
    super.key,
  });

  final Widget child;
  final double borderRadius;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(borderOpacity),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// Interactive glass button with hover/press effects
class GlassButton extends StatefulWidget {
  const GlassButton({
    required this.child,
    required this.onTap,
    this.borderRadius = 20,
    this.blur = 10,
    this.opacity = 0.25,
    this.glowColor,
    this.pressedColor,
    this.baseColor,
    this.padding,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? glowColor;
  final Color? pressedColor;
  final Color? baseColor;
  final EdgeInsetsGeometry? padding;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaleButton(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isPressed && widget.pressedColor != null
                  ? widget.pressedColor!.withOpacity(0.85)
                  : widget.baseColor != null
                        ? widget.baseColor!.withOpacity(0.6)
                      : Colors.white.withOpacity(
                          _isPressed ? widget.opacity * 2 : widget.opacity,
                        ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: _isPressed && widget.pressedColor != null
                    ? widget.pressedColor!
                    : widget.baseColor != null
                        ? widget.baseColor!
                        : Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: (widget.glowColor ?? Colors.white).withOpacity(
                    widget.baseColor != null ? 0.3 : (_isPressed ? 0.4 : 0.2),
                  ),
                  blurRadius: widget.baseColor != null ? 14 : (_isPressed ? 20 : 10),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: widget.padding,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Circular glass button for icons
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    required this.icon,
    required this.onTap,
    this.size = 50,
    this.blur = 8,
    this.opacity = 0.2,
    super.key,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      onTap: onTap,
      borderRadius: size / 2,
      blur: blur,
      opacity: opacity,
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}

/// Glass container with glow effect
class GlowingGlassCard extends StatelessWidget {
  const GlowingGlassCard({
    required this.child,
    this.borderRadius = 30,
    this.blur = 12,
    this.opacity = 0.25,
    this.glowColor = Colors.white,
    this.glowStrength = 0.3,
    this.padding,
    super.key,
  });

  final Widget child;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color glowColor;
  final double glowStrength;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(glowStrength),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
