import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_war/core/cubit/game_state.dart';
import 'package:math_war/core/models/game_config.dart';
import 'package:math_war/core/services/math_generator.dart';
import 'package:math_war/core/services/score_calculator.dart';
import 'package:math_war/core/services/storage_service.dart';

/// Cubit managing the game state and logic
class GameCubit extends Cubit<GameState> {
  final MathGenerator _mathGenerator;
  final StorageService _storageService;
  
  GameConfig _currentConfig = GameConfig.defaultConfig();
  Timer? _timer;

  GameCubit({
    required MathGenerator mathGenerator,
    required StorageService storageService,
  })  : _mathGenerator = mathGenerator,
        _storageService = storageService,
        super(GameState.initial()) {
    _loadInitialData();
  }

  /// Load initial data from storage
  void _loadInitialData() {
    final bestScore = _storageService.getBestScore();
    final totalScore = _storageService.getTotalScore();
    final config = _storageService.getGameConfig();
    
    _currentConfig = config;
    
    emit(state.copyWith(
      bestScore: bestScore,
      totalScore: totalScore,
    ));
  }

  /// Get current game configuration
  GameConfig get currentConfig => _currentConfig;

  /// Update game configuration
  Future<void> updateConfig(GameConfig config) async {
    _currentConfig = config;
    await _storageService.saveGameConfig(config);
  }

  /// Start a new game
  void startGame() {
    _timer?.cancel();
    
    // Generate first equation based on initial score (0)
    final equation = _mathGenerator.generateEquation(
      config: _currentConfig,
      currentScore: 0,
    );

    emit(GameState(
      status: GameStatus.playing,
      currentScore: 0,
      bestScore: state.bestScore,
      totalScore: state.totalScore,
      currentEquation: equation,
      remainingTime: _currentConfig.timeLimit,
      totalTime: _currentConfig.timeLimit,
      consecutiveCorrect: 0,
    ));

    _startTimer();
  }

  /// Prepare game (generate equation without starting timer)
  void prepareGame() {
    _timer?.cancel();
    
    // Generate first equation based on initial score (0)
    final equation = _mathGenerator.generateEquation(
      config: _currentConfig,
      currentScore: 0,
    );

    emit(GameState(
      status: GameStatus.playing,
      currentScore: 0,
      bestScore: state.bestScore,
      totalScore: state.totalScore,
      currentEquation: equation,
      remainingTime: _currentConfig.timeLimit,
      totalTime: _currentConfig.timeLimit,
      consecutiveCorrect: 0,
    ));
  }

  /// Start the timer after countdown
  void startTimer() {
    _startTimer();
  }

  /// Start countdown timer
  void _startTimer() {
    _timer?.cancel();
    
    const tickDuration = Duration(milliseconds: 50); // 20 ticks per second for smooth animation
    
    _timer = Timer.periodic(tickDuration, (timer) {
      if (state.status != GameStatus.playing) {
        timer.cancel();
        return;
      }

      final newRemainingTime = state.remainingTime - tickDuration.inMilliseconds / 1000;
      
      if (newRemainingTime <= 0) {
        timer.cancel();
        _handleTimeout();
      } else {
        emit(state.copyWith(remainingTime: newRemainingTime));
      }
    });
  }

  /// Handle timeout (same as wrong answer)
  void _handleTimeout() {
    _gameOver();
  }

  /// Handle user answer
  Future<void> answerQuestion(bool userAnswerIsTrue) async {
    if (state.status != GameStatus.playing || state.currentEquation == null) {
      return;
    }

    _timer?.cancel();

    final isCorrect = userAnswerIsTrue == state.currentEquation!.isCorrect;

    if (!isCorrect) {
      // Wrong answer - game over
      _gameOver();
      return;
    }

    // Correct answer - calculate score and continue
    final earnedScore = ScoreCalculator.calculateScore(
      state.remainingTime,
      state.totalTime,
    );

    final newCurrentScore = state.currentScore + earnedScore;
    final newConsecutiveCorrect = state.consecutiveCorrect + 1;
    final newTotalScore = state.totalScore + earnedScore;

    // Update best score if needed
    int newBestScore = state.bestScore;
    if (newCurrentScore > state.bestScore) {
      newBestScore = newCurrentScore;
      await _storageService.saveBestScore(newBestScore);
    }

    // Save total score
    await _storageService.saveTotalScore(newTotalScore);

    // Generate next equation based on new current score
    final nextEquation = _mathGenerator.generateEquation(
      config: _currentConfig,
      currentScore: newCurrentScore,
    );

    emit(state.copyWith(
      currentScore: newCurrentScore,
      bestScore: newBestScore,
      totalScore: newTotalScore,
      currentEquation: nextEquation,
      remainingTime: _currentConfig.timeLimit,
      consecutiveCorrect: newConsecutiveCorrect,
    ));

    _startTimer();
  }

  /// End the game
  void _gameOver() {
    _timer?.cancel();
    
    // First emit wrongAnswer status for shake animation
    emit(state.copyWith(
      status: GameStatus.wrongAnswer,
      remainingTime: 0,
    ));
    
    // After delay, emit gameOver status
    Future.delayed(const Duration(milliseconds: 1500), () {
      emit(state.copyWith(
        status: GameStatus.gameOver,
      ));
    });
  }

  /// Reset to initial state
  void resetGame() {
    _timer?.cancel();
    
    emit(state.copyWith(
      status: GameStatus.initial,
      currentScore: 0,
      remainingTime: _currentConfig.timeLimit,
      totalTime: _currentConfig.timeLimit,
      consecutiveCorrect: 0,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
