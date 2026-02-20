import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_war/common/app_route.dart';
import 'package:math_war/core/cubit/game_cubit.dart';
import 'package:math_war/core/cubit/game_state.dart';
import 'package:math_war/l10n/app_localizations.dart';
import 'package:math_war/screens/settings_screen.dart';
import 'package:math_war/theme/neumorphic_theme_extension.dart';
import 'package:math_war/widgets/neumorphic/neumorphic_widgets.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NeuScaffold(
      child: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          final isNewRecord =
              state.currentScore > 0 && state.currentScore == state.bestScore;

          return LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth =
                  constraints.maxWidth > 540 ? 540.0 : constraints.maxWidth;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(l10n.results,
                              style: Theme.of(context).textTheme.titleLarge),
                          const Spacer(),
                          NeuIconButton(
                            icon: Icons.settings_rounded,
                            onTap: () => Navigator.push(
                                context, playfulRoute(const SettingsScreen())),
                          ),
                        ],
                      ),
                      const Spacer(),
                      NeuSurface(
                        radius: 32,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                                'assets/illustrations/illus_game_over_fun.svg',
                                height: 162),
                            const SizedBox(height: 10),
                            Text(l10n.outOfTurns,
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 8),
                            Text(
                              isNewRecord ? l10n.newRecordMsg : l10n.retryMsg,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 14),
                            _scoreGrid(state, isNewRecord, l10n),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: NeuButton(
                          onTap: () {
                            context.read<GameCubit>().resetGame();
                            Navigator.pop(context);
                          },
                          radius: 28,
                          color: const Color(0xFFFFD89E),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.refresh_rounded),
                              const SizedBox(width: 8),
                              Text(l10n.playAgain),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _scoreGrid(GameState state, bool isNewRecord, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
            child: _metric(l10n.points, state.currentScore.toString(),
                Icons.bolt_rounded)),
        const SizedBox(width: 10),
        Expanded(
            child: _metric(l10n.highest, state.bestScore.toString(),
                Icons.workspace_premium_rounded)),
        const SizedBox(width: 10),
        Expanded(
            child: _metric(
                l10n.status,
                isNewRecord ? l10n.newLabel : l10n.okLabel,
                Icons.favorite_rounded)),
      ],
    );
  }

  Widget _metric(String title, String value, IconData icon) {
    return NeuSurface(
      radius: 20,
      pressed: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6B7CFF)),
          const SizedBox(height: 4),
          Text(title,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
