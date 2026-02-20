import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_war/common/app_route.dart';
import 'package:math_war/core/cubit/game_cubit.dart';
import 'package:math_war/core/cubit/game_state.dart';
import 'package:math_war/core/cubit/theme_cubit.dart';
import 'package:math_war/l10n/app_localizations.dart';
import 'package:math_war/screens/game_screen.dart';
import 'package:math_war/screens/settings_screen.dart';
import 'package:math_war/theme/neumorphic_theme_extension.dart';
import 'package:math_war/widgets/neumorphic/neumorphic_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NeuScaffold(
      child: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth =
                  constraints.maxWidth > 560 ? 560.0 : constraints.maxWidth;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _header(context, l10n),
                      const SizedBox(height: 14),
                      _titleCard(context, constraints, l10n),
                      const SizedBox(height: 14),
                      _scoreRow(context, state, l10n),
                      const Spacer(),
                      _startButton(context, l10n),
                      const SizedBox(height: 12),
                      _quickNav(context, l10n),
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

  Widget _header(BuildContext context, AppLocalizations l10n) {
    final themeCubit = context.read<ThemeCubit>();

    return Row(
      children: [
        Text(l10n.mathPlayground,
            style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        NeuIconButton(
          icon: Icons.brightness_6_rounded,
          onTap: () {
            final next = switch (themeCubit.state) {
              ThemePreference.system => ThemePreference.light,
              ThemePreference.light => ThemePreference.dark,
              ThemePreference.dark => ThemePreference.system,
            };
            themeCubit.setPreference(next);
          },
        ),
        const SizedBox(width: 10),
        NeuIconButton(
          icon: Icons.settings_rounded,
          onTap: () =>
              Navigator.push(context, playfulRoute(const SettingsScreen())),
        ),
      ],
    );
  }

  Widget _titleCard(
      BuildContext context, BoxConstraints constraints, AppLocalizations l10n) {
    final neu = context.neu;

    return NeuSurface(
      radius: 30,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/illustrations/mascot_buddy.svg',
                  width: 72, height: 72),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.appTitle,
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(l10n.tagline,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SvgPicture.asset(
              'assets/illustrations/illus_home_fun.svg',
              height: constraints.maxHeight > 760 ? 170 : 144,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.stars_rounded, color: neu.accent),
              const SizedBox(width: 6),
              Text(l10n.unlockStars,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreRow(
      BuildContext context, GameState state, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
            child: _scoreCard(context, l10n.best, state.bestScore,
                Icons.emoji_events_rounded)),
        const SizedBox(width: 10),
        Expanded(
            child: _scoreCard(context, l10n.total, state.totalScore,
                Icons.auto_awesome_rounded)),
      ],
    );
  }

  Widget _scoreCard(
      BuildContext context, String label, int score, IconData icon) {
    return NeuSurface(
      radius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.neu.accent.withOpacity(0.28),
            ),
            child: Icon(icon, size: 20, color: context.neu.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
                Text('$score',
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _startButton(BuildContext context, AppLocalizations l10n) {
    final neu = context.neu;

    return SizedBox(
      width: double.infinity,
      child: NeuButton(
        onTap: () => Navigator.push(context, playfulRoute(const GameScreen())),
        radius: 30,
        color: const Color(0xFF97E8AE),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_fill_rounded,
                color: neu.textPrimary, size: 28),
            const SizedBox(width: 10),
            Text(
              l10n.startGame,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: neu.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickNav(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: NeuButton(
            onTap: () {},
            radius: 22,
            color: const Color(0xFFFFD89E),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.home_rounded),
                const SizedBox(width: 6),
                Text(l10n.home),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: NeuButton(
            onTap: () =>
                Navigator.push(context, playfulRoute(const SettingsScreen())),
            radius: 22,
            color: const Color(0xFFAEDBFF),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tune_rounded),
                const SizedBox(width: 6),
                Text(l10n.settings),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
