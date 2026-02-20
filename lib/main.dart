import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/cubit/game_cubit.dart';
import 'core/cubit/locale_cubit.dart';
import 'core/cubit/theme_cubit.dart';
import 'l10n/app_localizations.dart';
import 'core/services/math_generator.dart';
import 'core/services/storage_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize storage service
  final storageService = await StorageService.init();

  runApp(MathWarApp(storageService: storageService));
}

class MathWarApp extends StatelessWidget {
  final StorageService storageService;

  const MathWarApp({
    super.key,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GameCubit(
            mathGenerator: MathGenerator(),
            storageService: storageService,
          ),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(storageService: storageService),
        ),
        BlocProvider(
          create: (context) => LocaleCubit(storageService: storageService),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemePreference>(
        builder: (context, __) {
          final themeCubit = context.read<ThemeCubit>();
          return BlocBuilder<LocaleCubit, LanguagePreference>(
            builder: (context, _) {
              final localeCubit = context.read<LocaleCubit>();
              return MaterialApp(
                title: 'Math War',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeCubit.themeMode,
                locale: localeCubit.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                localeResolutionCallback: (locale, supportedLocales) {
                  if (locale == null) return supportedLocales.first;
                  for (final supported in supportedLocales) {
                    if (supported.languageCode == locale.languageCode) {
                      return supported;
                    }
                  }
                  return supportedLocales.first;
                },
                home: const HomeScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
