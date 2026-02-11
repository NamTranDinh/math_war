import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_war/core/cubit/game_cubit.dart';
import 'package:math_war/core/cubit/game_state.dart';
import 'package:math_war/widgets/glass_card.dart';
import 'package:math_war/common/common_button.dart';
import 'settings_screen.dart';
import 'game_screen.dart';

/// Home screen with logo, scores, and start button
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Continuous bounce animation for crown
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Indigo-blue gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4f46e5), // indigo-600
                  Color(0xFF3b82f6), // blue-500
                ],
              ),
            ),
          ),

          // Floating decorative elements
          Positioned(
            top: 100,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          // Main content with liquid glass
          SafeArea(
            child: BlocBuilder<GameCubit, GameState>(
              builder: (context, state) {
                return Column(
                  children: [
                    // Header with scores and settings
                    _buildHeader(context, state),

                    const Spacer(),

                    // Logo and title
                    _buildLogo(),

                    const SizedBox(height: 20),

                    _buildTitle(),

                    const SizedBox(height: 10),

                    _buildSubtitle(),

                    const Spacer(),

                    // Start button
                    _buildStartButton(context),

                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GameState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Best score without border
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BEST',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${state.bestScore}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Total score without border
          Column(
            children: [
              Text(
                'TOTAL SCORE',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${state.totalScore}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Settings button without border
          CommonScaleButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: GlowingGlassCard(
            borderRadius: 40,
            blur: 12,
            opacity: 0.25,
            glowColor: const Color(0xFFfbbf24),
            // yellow glow
            glowStrength: 0.4,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: Icon(
                  Icons.emoji_events, // crown/trophy icon
                  size: 70,
                  color: Color(0xFFfbbf24), // yellow-400
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return const Text(
      'MATH WAR',
      style: TextStyle(
        color: Colors.white,
        fontSize: 42,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Test your reflexes. Conquer the numbers.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: CommonScaleButton(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const GameScreen(),
              ),
            );
          },
          child: Material(
            color: const Color(0xFF002C71).withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
            child: const Center(
              child: Text(
                'START BATTLE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
