import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_war/l10n/app_localizations.dart';
import 'package:math_war/theme/neumorphic_theme_extension.dart';
import 'package:math_war/widgets/neumorphic/neumorphic_widgets.dart';

class CountdownOverlay extends StatefulWidget {
  const CountdownOverlay({required this.onComplete, super.key});

  final VoidCallback onComplete;

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  int _currentCount = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _startCountdown();
  }

  Future<void> _startCountdown() async {
    for (int i = 3; i >= 0; i--) {
      if (!mounted) {
        return;
      }
      setState(() => _currentCount = i);
      _controller.forward(from: 0);
      await Future.delayed(Duration(milliseconds: i == 3 ? 900 : 700));
    }

    if (!mounted) {
      return;
    }
    setState(() => _currentCount = -1);
    _controller.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = _currentCount > 0
        ? '$_currentCount'
        : (_currentCount == 0 ? l10n.ready : l10n.start);
    final fontSize = _currentCount > 0 ? 76.0 : 38.0;

    return Material(
      color: Colors.black.withOpacity(0.25),
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: NeuSurface(
            radius: 36,
            color: context.neu.surface,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/illustrations/mascot_buddy.svg',
                    width: 56, height: 56),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: context.neu.accent),
                    const SizedBox(width: 6),
                    Text(
                      text,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: context.neu.accent,
                                fontSize: fontSize,
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
