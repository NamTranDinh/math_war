import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common/common_button.dart';
import '../core/cubit/game_cubit.dart';
import '../core/models/game_config.dart';
import '../core/models/math_operation.dart';

/// Settings screen (War Room) for configuring game parameters
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
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.85 > 350
                            ? 350
                            : MediaQuery.of(context).size.width * 0.85,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title
                          const Text(
                            'WAR ROOM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Operations section
                          _buildSectionTitle('OPERATIONS'),
                          const SizedBox(height: 8),
                          _buildOperationsGrid(),

                          const SizedBox(height: 16),

                          // Max difficulty
                          _buildSectionTitle('⚡ MAX DIFFICULTY'),
                          const SizedBox(height: 6),
                          _buildDifficultySlider(),

                          const SizedBox(height: 14),

                          // Time limit
                          _buildSectionTitle('⏱ TIME LIMIT'),
                          const SizedBox(height: 6),
                          _buildTimeSlider(),

                          const SizedBox(height: 20),

                          // Save button
                          _buildSaveButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CommonScaleButton(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
          ),
          const Spacer(),
          Text(
            'BEST',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            'TOTAL SCORE',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          CommonScaleButton(
            onTap: () {},
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

  Widget _buildSectionTitle(String title) {
    String? infoText;

    // Set info text based on title
    if (title == 'OPERATIONS') {
      infoText =
          'Choose which math operations to include in the game. You must have at least one operation enabled. Mix different operations to make the game more challenging!';
    } else if (title.contains('MAX DIFFICULTY')) {
      infoText =
          'Controls the maximum number of digits in the math problems. Level 1 uses single-digit numbers (1-9), Level 5 uses five-digit numbers (10000-99999). Higher levels are more challenging!';
    } else if (title.contains('TIME LIMIT')) {
      infoText =
          'Sets how many seconds you have to answer each question. Shorter time limits make the game more intense and challenging. Default is 3 seconds per question.';
    }

    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        if (infoText != null) ...[
          const SizedBox(width: 6),
          CommonScaleButton(
            onTap: () => _showInfoDialog(title, infoText!),
            child: Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeOutBack,
          ),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Main dialog centered
                Container(
                  constraints: const BoxConstraints(maxWidth: 340),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with colored background
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF4f46e5),
                              Color(0xFF3b82f6),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.info,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Color(0xFF1f2937),
                            fontSize: 14,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),

                      // Button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4f46e5),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'GOT IT',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bot image positioned on the top right side
                Positioned(
                  right: -20,
                  top: -80,
                  child: Image.asset(
                    'assets/images/img_bot_info.png',
                    fit: BoxFit.fitWidth,
                    width: 180,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to emoji if image not found
                      return const ColoredBox(
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            '🤖',
                            style: TextStyle(fontSize: 60),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOperationsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.2,
      children: [
        _buildOperationButton(OperationType.add),
        _buildOperationButton(OperationType.subtract),
        _buildOperationButton(OperationType.multiply),
        _buildOperationButton(OperationType.divide),
      ],
    );
  }

  Widget _buildOperationButton(OperationType operation) {
    final isEnabled = _enabledOperations.contains(operation);

    return CommonScaleButton(
      onTap: () {
        setState(() {
          if (isEnabled) {
            // Keep at least one operation enabled
            if (_enabledOperations.length > 1) {
              _enabledOperations.remove(operation);
            }
          } else {
            _enabledOperations.add(operation);
          }
        });
      },
      child: Material(
        color: isEnabled ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Center(
            child: Text(
              operation.displayName,
              style: TextStyle(
                color: isEnabled ? const Color(0xFF4f46e5) : Colors.white.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultySlider() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level ${_maxDifficultyLevel.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.whatshot,
                color: Colors.orange,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackHeight: 4,
            ),
            child: Slider(
              value: _maxDifficultyLevel,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  _maxDifficultyLevel = value;
                });
              },
            ),
          ),
          Text(
            'Scales from 1-digit up to ${_maxDifficultyLevel.toInt()}-digit numbers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlider() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_timeLimit.toStringAsFixed(1)}s',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.timer,
                color: Colors.lightBlueAccent,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackHeight: 4,
            ),
            child: Slider(
              value: _timeLimit,
              min: 1.0,
              max: 5.0,
              divisions: 40,
              onChanged: (value) {
                setState(() {
                  _timeLimit = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: CommonScaleButton(
        onTap: () {
          final newConfig = GameConfig(
            enabledOperations: _enabledOperations,
            maxDifficultyLevel: _maxDifficultyLevel.toInt(),
            timeLimit: _timeLimit,
          );

          context.read<GameCubit>().updateConfig(newConfig);

          Navigator.pop(context);
        },
        child: Material(
          color: const Color(0xFF4f46e5).withOpacity(0.3), // Dark indigo initially
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              'SAVE CONFIG',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
