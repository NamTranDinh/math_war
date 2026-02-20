import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_war/core/cubit/game_cubit.dart';
import 'package:math_war/core/cubit/locale_cubit.dart';
import 'package:math_war/core/cubit/theme_cubit.dart';
import 'package:math_war/core/models/game_config.dart';
import 'package:math_war/core/models/math_operation.dart';
import 'package:math_war/l10n/app_localizations.dart';
import 'package:math_war/l10n/operation_localization.dart';
import 'package:math_war/theme/neumorphic_theme_extension.dart';
import 'package:math_war/widgets/neumorphic/neumorphic_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Set<OperationType> _enabledOperations;
  late double _maxDifficultyLevel;
  late double _timeLimit;

  @override
  void initState() {
    super.initState();
    final config = context.read<GameCubit>().currentConfig;
    _enabledOperations = Set.from(config.enabledOperations);
    _maxDifficultyLevel = config.maxDifficultyLevel.toDouble();
    _timeLimit = config.timeLimit;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NeuScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth =
              constraints.maxWidth > 560 ? 560.0 : constraints.maxWidth;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  _header(context, l10n),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        NeuSurface(
                          radius: 24,
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/illustrations/mascot_buddy.svg',
                                      width: 36,
                                      height: 36),
                                  const SizedBox(width: 8),
                                  Text(l10n.ui,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  const Spacer(),
                                  SvgPicture.asset(
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? 'assets/icons/ic_theme_dark.svg'
                                        : 'assets/icons/ic_theme_light.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _themeSelector(context, l10n),
                              const SizedBox(height: 10),
                              Text(l10n.language,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              _languageSelector(context, l10n),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        NeuSurface(
                          radius: 24,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader(
                                  l10n.operations, l10n.chooseOperation),
                              const SizedBox(height: 8),
                              _operationsGrid(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        NeuSurface(
                          radius: 24,
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader(
                                  l10n.maxDifficulty, l10n.difficultyHint),
                              const SizedBox(height: 6),
                              Text(
                                l10n.level(_maxDifficultyLevel.toInt()),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Slider(
                                value: _maxDifficultyLevel,
                                min: 1,
                                max: 5,
                                divisions: 4,
                                onChanged: (value) =>
                                    setState(() => _maxDifficultyLevel = value),
                              ),
                              const SizedBox(height: 2),
                              _sectionHeader(l10n.timeLimit, l10n.timeHint),
                              const SizedBox(height: 6),
                              Text(
                                l10n.seconds(_timeLimit.toStringAsFixed(1)),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Slider(
                                value: _timeLimit,
                                min: 1.0,
                                max: 5.0,
                                divisions: 40,
                                onChanged: (value) =>
                                    setState(() => _timeLimit = value),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: NeuButton(
                      onTap: () {
                        final newConfig = GameConfig(
                          enabledOperations: _enabledOperations,
                          maxDifficultyLevel: _maxDifficultyLevel.toInt(),
                          timeLimit: _timeLimit,
                        );
                        context.read<GameCubit>().updateConfig(newConfig);
                        Navigator.pop(context);
                      },
                      radius: 26,
                      color: const Color(0xFFAEDBFF),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Center(
                        child: Text(
                          l10n.saveSettings,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: context.neu.textPrimary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        NeuIconButton(
          size: 42,
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(width: 10),
        Text(l10n.settings, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _themeSelector(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<ThemeCubit, ThemePreference>(
      builder: (context, selectedTheme) {
        return Row(
          children: [
            Expanded(
              child: NeuChoiceChip(
                label: l10n.system,
                selected: selectedTheme == ThemePreference.system,
                onTap: () => context
                    .read<ThemeCubit>()
                    .setPreference(ThemePreference.system),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: NeuChoiceChip(
                label: l10n.light,
                selected: selectedTheme == ThemePreference.light,
                onTap: () => context
                    .read<ThemeCubit>()
                    .setPreference(ThemePreference.light),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: NeuChoiceChip(
                label: l10n.dark,
                selected: selectedTheme == ThemePreference.dark,
                onTap: () => context
                    .read<ThemeCubit>()
                    .setPreference(ThemePreference.dark),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _languageSelector(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<LocaleCubit, LanguagePreference>(
      builder: (context, selectedLanguage) {
        return Row(
          children: [
            Expanded(
              child: NeuChoiceChip(
                label: l10n.system,
                selected: selectedLanguage == LanguagePreference.system,
                onTap: () => context
                    .read<LocaleCubit>()
                    .setPreference(LanguagePreference.system),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: NeuChoiceChip(
                label: l10n.english,
                selected: selectedLanguage == LanguagePreference.en,
                onTap: () => context
                    .read<LocaleCubit>()
                    .setPreference(LanguagePreference.en),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: NeuChoiceChip(
                label: l10n.vietnamese,
                selected: selectedLanguage == LanguagePreference.vi,
                onTap: () => context
                    .read<LocaleCubit>()
                    .setPreference(LanguagePreference.vi),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionHeader(String title, String description) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: 6),
        NeuIconButton(
          icon: Icons.info_outline_rounded,
          size: 30,
          onTap: () => _showInfoDialog(title, description),
        ),
      ],
    );
  }

  void _showInfoDialog(String title, String description) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: NeuSurface(
            radius: 18,
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(description,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 90,
                    child: NeuButton(
                      onTap: () => Navigator.pop(context),
                      radius: 14,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                          child: Text(context.l10n.close,
                              style: Theme.of(context).textTheme.labelLarge)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _operationsGrid() {
    final items = <OperationType>[
      OperationType.add,
      OperationType.subtract,
      OperationType.multiply,
      OperationType.divide,
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 3.1,
      ),
      itemBuilder: (context, index) {
        final operation = items[index];
        final isEnabled = _enabledOperations.contains(operation);

        return NeuChoiceChip(
          label: operation.localizedLabel(context),
          selected: isEnabled,
          onTap: () {
            setState(() {
              if (isEnabled && _enabledOperations.length > 1) {
                _enabledOperations.remove(operation);
              } else if (!isEnabled) {
                _enabledOperations.add(operation);
              }
            });
          },
        );
      },
    );
  }
}
