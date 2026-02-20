import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_war/common/app_route.dart';
import 'package:math_war/core/cubit/game_cubit.dart';
import 'package:math_war/core/cubit/game_state.dart';
import 'package:math_war/l10n/app_localizations.dart';
import 'package:math_war/screens/countdown_overlay.dart';
import 'package:math_war/screens/game_over_screen.dart';
import 'package:math_war/theme/neumorphic_theme_extension.dart';
import 'package:math_war/widgets/celebration_overlay.dart';
import 'package:math_war/widgets/neumorphic/neumorphic_widgets.dart';
import 'package:vibration/vibration.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  late final AnimationController _scorePulseController;
  late final Animation<double> _scorePulse;
  int _celebrationTick = 0;
  int _lastScore = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 460));
    _shakeAnimation = CurvedAnimation(parent: _shakeController, curve: Curves.easeOutBack);

    _scorePulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _scorePulse = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _scorePulseController, curve: Curves.easeOutBack),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<GameCubit>().prepareGame();
      _showCountdown();
    });
  }

  void _showCountdown() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (dialogContext) {
        return CountdownOverlay(
          onComplete: () {
            Navigator.of(dialogContext).pop();
            context.read<GameCubit>().startTimer();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _scorePulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (state.currentScore > _lastScore) {
          setState(() {
            _celebrationTick++;
            _lastScore = state.currentScore;
          });
          _scorePulseController
            ..reset()
            ..forward();
        }

        if (state.status == GameStatus.wrongAnswer) {
          _shakeController.forward(from: 0);
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(l10n.wrongTryAgain)));
        }

        if (state.status == GameStatus.gameOver) {
          Navigator.pushReplacement(context, playfulRoute(const GameOverScreen()));
        }
      },
      builder: (context, state) => NeuScaffold(
        child: BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            return Stack(
              children: [
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    final progress = _shakeAnimation.value;
                    final shift = (progress < 0.5 ? 1 : -1) * progress * (1 - progress) * 30;
                    return Transform.translate(offset: Offset(shift, 0), child: child);
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = constraints.maxWidth > 560 ? 560.0 : constraints.maxWidth;

                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              _header(state, l10n),
                              const SizedBox(height: 14),
                              NeuProgressBar(value: state.remainingTime / state.totalTime),
                              const SizedBox(height: 16),
                              Expanded(child: _questionCard(state, l10n)),
                              const SizedBox(height: 14),
                              _answerButtons(context, l10n),
                              const SizedBox(height: 18),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                CelebrationOverlay(trigger: _celebrationTick),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(GameState state, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: _miniScore(l10n.best, state.bestScore, Icons.workspace_premium_rounded)),
        const SizedBox(width: 10),
        Expanded(
          child: ScaleTransition(
            scale: _scorePulse,
            child: _miniScore(l10n.score, state.currentScore, Icons.bolt_rounded),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: _miniScore(l10n.total, state.totalScore, Icons.star_rounded)),
      ],
    );
  }

  Widget _miniScore(String title, int value, IconData icon) {
    return NeuSurface(
      radius: 22,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: context.neu.accent),
              const SizedBox(width: 4),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: Text(
              '$value',
              key: ValueKey<int>(value),
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionCard(GameState state, AppLocalizations l10n) {
    if (state.currentEquation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final question = '${state.currentEquation!.questionText} = ${state.currentEquation!.displayedResult}';

    return Center(
      child: NeuSurface(
        radius: 36,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/illustrations/mascot_buddy.svg', width: 42, height: 42),
                const SizedBox(width: 8),
                Text(l10n.youCanDoIt, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              question,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 42),
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerButtons(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: NeuButton(
            onTap: () => _answer(context, false),
            color: const Color(0xFFFFB8C5),
            radius: 28,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.close_rounded, size: 28),
                const SizedBox(width: 8),
                Text(l10n.falseLabel),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: NeuButton(
            onTap: () => _answer(context, true),
            color: const Color(0xFFABE8BC),
            radius: 28,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_rounded, size: 28),
                const SizedBox(width: 8),
                Text(l10n.trueLabel),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _answer(BuildContext context, bool value) async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 45);
    }

    if (context.mounted) {
      context.read<GameCubit>().answerQuestion(value);
    }
  }
}
