import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common/common_button.dart';
import '../core/cubit/game_cubit.dart';
import '../core/cubit/game_state.dart';
import 'settings_screen.dart';

/// Game Over screen showing final score and re-engage option
class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: BlocBuilder<GameCubit, GameState>(
            builder: (context, state) {
              return Column(
                children: [
                  // Header
                  _buildHeader(state),
                  
                  const Spacer(),
                  
                  // Result image
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildResultImage(state),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Strike Out text
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'STRIKE OUT!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Final score
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildScoreCard(state),
                  ),
                  
                  const Spacer(),
                  
                  // Re-engage button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildReEngageButton(context),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(GameState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BEST',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
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
          Column(
            children: [
              Text(
                'TOTAL SCORE',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
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
          CommonScaleButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
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

  Widget _buildResultImage(GameState state) {
    final isNewRecord = state.currentScore == state.bestScore && state.currentScore > 0;
    final imagePath = isNewRecord
        ? 'assets/images/img_bot_congrats.png'
        : 'assets/images/img_bot_gameover.png';

    return Image.asset(
      imagePath,
      width: 220,
      height: 220,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Text(
            '🏆',
            style: TextStyle(fontSize: 70),
          ),
        );
      },
    );
  }

  Widget _buildScoreCard(GameState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF3A2FB5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'FINAL SCORE',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${state.currentScore}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (state.currentScore == state.bestScore && state.currentScore > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'NEW RECORD! 🎉',
                  style: TextStyle(
                    color: Color(0xFF3A2FB5),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReEngageButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: CommonScaleButton(
          onTap: () {
            context.read<GameCubit>().resetGame();
            Navigator.pop(context);
          },
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.3),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh_rounded,
                  size: 28,
                  color: Color(0xFF5B52E8),
                ),
                SizedBox(width: 8),
                Text(
                  'RE-ENGAGE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: Color(0xFF5B52E8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
