import 'package:flutter/material.dart';

/// Countdown overlay before game starts (3, 2, 1, GO!)
class CountdownOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const CountdownOverlay({
    required this.onComplete,
    super.key,
  });

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _currentCount = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _startCountdown();
  }

  void _startCountdown() async {
    // Show 3 with extra delay
    setState(() => _currentCount = 3);
    _controller.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 1900));

    // Show 2 and 1
    for (int i = 2; i >= 1; i--) {
      setState(() => _currentCount = i);
      _controller.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 900));
    }

    setState(() => _currentCount = 0);
    _controller.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _currentCount = -1);
    _controller.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 500));

    widget.onComplete();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String text;
    double fontSize;
    
    if (_currentCount > 0) {
      text = '$_currentCount';
      fontSize = 120;
    } else if (_currentCount == 0) {
      text = 'READY';
      fontSize = 70;
    } else {
      text = 'GO!';
      fontSize = 80;
    }
    
    return Material(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
              shadows: const [
                Shadow(
                  color: Colors.black,
                  blurRadius: 20,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
