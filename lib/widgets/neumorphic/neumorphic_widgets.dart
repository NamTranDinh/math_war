import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_war/common/common_button.dart';
import 'package:math_war/theme/neumorphic_theme_extension.dart';

class NeuScaffold extends StatelessWidget {
  const NeuScaffold({
    required this.child,
    this.padding,
    this.showBackgroundShapes = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool showBackgroundShapes;

  @override
  Widget build(BuildContext context) {
    final neu = context.neu;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              neu.background,
              Color.lerp(neu.background, neu.surface, 0.85)!,
            ],
          ),
        ),
        child: Stack(
          children: [
            if (showBackgroundShapes) ...[
              Positioned(top: -90, right: -50, child: _cloud(neu, 190)),
              Positioned(top: 160, left: -70, child: _cloud(neu, 140)),
              Positioned(bottom: 110, right: -60, child: _cloud(neu, 150)),
              const Positioned(right: 10, bottom: 8, child: _MascotBubble()),
            ],
            SafeArea(
              child: Padding(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cloud(NeumorphicThemeExtension neu, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: neu.accent.withOpacity(0.12),
      ),
    );
  }
}

class _MascotBubble extends StatelessWidget {
  const _MascotBubble();

  @override
  Widget build(BuildContext context) {
    final neu = context.neu;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1300),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(value * math.pi * 2) * 4),
          child: child,
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: neu.surface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: neu.shadowDark,
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            'assets/illustrations/mascot_buddy.svg',
            width: 54,
            height: 54,
          ),
        ),
      ),
    );
  }
}

class NeuSurface extends StatelessWidget {
  const NeuSurface({
    required this.child,
    this.radius = 24,
    this.padding,
    this.margin,
    this.pressed = false,
    this.color,
    super.key,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool pressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final neu = context.neu;
    final baseColor = color ?? neu.surface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: baseColor,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.2),
        boxShadow: pressed
            ? [
                BoxShadow(
                  color: neu.shadowDark,
                  blurRadius: 6,
                  offset: const Offset(2, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: neu.shadowDark,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: neu.shadowLight.withOpacity(0.6),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
      ),
      child:
          Padding(padding: padding ?? const EdgeInsets.all(14), child: child),
    );
  }
}

class NeuButton extends StatefulWidget {
  const NeuButton({
    required this.onTap,
    required this.child,
    this.radius = 26,
    this.padding,
    this.color,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final neu = context.neu;

    return CommonScaleButton(
      scaleDown: 0.93,
      duration: const Duration(milliseconds: 110),
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color ?? neu.surface,
              Color.lerp(widget.color ?? neu.surface, neu.inset, 0.3)!,
            ],
          ),
          border: Border.all(
            color: _pressed
                ? Colors.white.withOpacity(0.25)
                : Colors.white.withOpacity(0.45),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: neu.shadowDark.withOpacity(_pressed ? 0.35 : 0.48),
              blurRadius: _pressed ? 8 : 16,
              offset: Offset(0, _pressed ? 4 : 8),
            ),
          ],
        ),
        child: Padding(
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: widget.child,
        ),
      ),
    );
  }
}

class NeuIconButton extends StatelessWidget {
  const NeuIconButton({
    required this.icon,
    required this.onTap,
    this.size = 54,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: NeuButton(
        onTap: onTap,
        radius: size / 2,
        padding: EdgeInsets.zero,
        child: Icon(icon, size: size * 0.46, color: context.neu.textPrimary),
      ),
    );
  }
}

class NeuProgressBar extends StatelessWidget {
  const NeuProgressBar({
    required this.value,
    super.key,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    final neu = context.neu;
    final clamped = value.clamp(0.0, 1.0);

    return NeuSurface(
      radius: 24,
      pressed: true,
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 16,
          child: LinearProgressIndicator(
            value: clamped,
            backgroundColor: neu.inset,
            color: clamped > 0.35 ? neu.accent : const Color(0xFFFF7B7B),
          ),
        ),
      ),
    );
  }
}

class NeuChoiceChip extends StatelessWidget {
  const NeuChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final neu = context.neu;

    return NeuButton(
      onTap: onTap,
      radius: 20,
      color: selected ? neu.accent.withOpacity(0.4) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (selected) ...[
            const Icon(Icons.star_rounded, size: 16),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color:
                        selected ? const Color(0xFF2F2B4A) : neu.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
