import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/cubit/game_cubit.dart';
import 'core/services/math_generator.dart';
import 'core/services/storage_service.dart';
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
    return BlocProvider(
      create: (context) => GameCubit(
        mathGenerator: MathGenerator(),
        storageService: storageService,
      ),
      child: MaterialApp(
        title: 'Math War',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF5B52E8),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'System',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
