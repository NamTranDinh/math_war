import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_war/core/cubit/game_state.dart';
import 'package:math_war/widgets/glass_card.dart';
import 'package:vibration/vibration.dart';
import '../core/cubit/game_cubit.dart';
import 'game_over_screen.dart';
import 'countdown_overlay.dart';

/// Main game screen with math equation and answer buttons
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;
  bool _countdownComplete = false;

  @override
  void initState() {
    super.initState();

    // Shake animation for wrong answers
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.easeInOut,
      ),
    );

    // Show countdown before starting game
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GameCubit>().prepareGame();
        _showCountdown();
      }
    });
  }

  void _showCountdown() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (dialogContext) => CountdownOverlay(
        onComplete: () {
          if (mounted) {
            Navigator.of(dialogContext).pop();
            setState(() => _countdownComplete = true);
            context.read<GameCubit>().startTimer();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  List<Color> _getGradientColors(int score) {
    // Change colors by 100-point stages: 0-99, 100-199, 200-299, 300+
    const gradients = <List<Color>>[
      [Color(0xFF4f46e5), Color(0xFF3b82f6)], // indigo → blue
      [Color(0xFFf97316), Color(0xFFeab308)], // orange → yellow
      [Color(0xFFe11d48), Color(0xFFec4899)], // rose → pink
      [Color(0xFF7e22ce), Color(0xFFc026d3), Color(0xFF4f46e5)], // purple → fuchsia → indigo
    ];

    final stage = (score ~/ 100).clamp(0, gradients.length - 1);
    return gradients[stage];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameState>(
      listener: (context, state) {
        if (state.status == GameStatus.wrongAnswer) {
          // Trigger shake animation
          _shakeController.forward(from: 0);
        } else if (state.status == GameStatus.gameOver) {
          // Navigate to game over screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const GameOverScreen(),
            ),
          );
        }
      },
      child: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          return Scaffold(
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getGradientColors(state.currentScore),
                ),
              ),
              child: SafeArea(
                child: AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    final progress = _shakeAnimation.value;
                    final shake = progress * (1 - progress) * 15;
                    final offset = shake * (progress < 0.5 ? 1 : -1);
                    
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(state),

                      // Timer
                      _buildTimer(state),

                      const SizedBox(height: 40),

                      // Question
                      Expanded(
                        child: _buildQuestion(state),
                      ),

                      const SizedBox(height: 40),

                      // Answer buttons
                      _buildAnswerButtons(context, state),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(GameState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GlassCard(
            borderRadius: 16,
            blur: 6,
            opacity: 0.18,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BEST',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.bestScore}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GlassCard(
            borderRadius: 16,
            blur: 6,
            opacity: 0.18,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Column(
              children: [
                Text(
                  'TOTAL SCORE',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.totalScore}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GlassIconButton(
            icon: Icons.settings,
            onTap: () {},
            size: 50,
            blur: 6,
            opacity: 0.18,
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(GameState state) {
    final progress = state.remainingTime / state.totalTime;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 50),
              tween: Tween<double>(begin: progress, end: progress),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    value > 0.5
                        ? Colors.white
                        : value > 0.25
                            ? Colors.yellow
                            : Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(GameState state) {
    if (state.currentEquation == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final equation = state.currentEquation!;

    return Center(
      child: GlowingGlassCard(
        borderRadius: 30,
        blur: 12,
        opacity: 1.0,
        glowColor: const Color(0xFFFFFFFF),
        glowStrength: 0.25,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 40,
        ),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0.8, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Text(
                '${equation.questionText} = ${equation.displayedResult}',
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Color(0x22000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnswerButtons(BuildContext context, GameState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: _buildAnswerButton(
              context,
              label: 'FALSE',
              isTrue: false,
              color: const Color(0xFFFF4D4D),
              icon: Icons.close,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _buildAnswerButton(
              context,
              label: 'TRUE',
              isTrue: true,
              color: const Color(0xFF22C55E),
              icon: Icons.check,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(
    BuildContext context, {
    required String label,
    required bool isTrue,
    required Color color,
    required IconData icon,
  }) {
    return SizedBox(
      height: 100,
      child: GlassButton(
        onTap: () async {
          // Haptic feedback
          if (await Vibration.hasVibrator() ?? false) {
            await Vibration.vibrate(duration: 50);
          }

          // Answer the question
          if (context.mounted) {
            context.read<GameCubit>().answerQuestion(isTrue);
          }
        },
        borderRadius: 20,
        blur: 10,
        opacity: 0.35,
        glowColor: color,
        baseColor: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
