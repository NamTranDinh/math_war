import 'package:equatable/equatable.dart';
import 'package:math_war/core/models/math_operation.dart';

/// Enum representing the current state of the game
enum GameStatus {
  initial,
  playing,
  wrongAnswer,
  gameOver,
}

/// State of the game
class GameState extends Equatable {
  final GameStatus status;
  final int currentScore;
  final int bestScore;
  final int totalScore;
  final MathEquation? currentEquation;
  final double remainingTime;
  final double totalTime;
  final int consecutiveCorrect; // Used for difficulty scaling

  const GameState({
    required this.status,
    required this.currentScore,
    required this.bestScore,
    required this.totalScore,
    this.currentEquation,
    required this.remainingTime,
    required this.totalTime,
    required this.consecutiveCorrect,
  });

  factory GameState.initial() {
    return const GameState(
      status: GameStatus.initial,
      currentScore: 0,
      bestScore: 0,
      totalScore: 0,
      currentEquation: null,
      remainingTime: 2.0,
      totalTime: 2.0,
      consecutiveCorrect: 0,
    );
  }

  GameState copyWith({
    GameStatus? status,
    int? currentScore,
    int? bestScore,
    int? totalScore,
    MathEquation? currentEquation,
    double? remainingTime,
    double? totalTime,
    int? consecutiveCorrect,
  }) {
    return GameState(
      status: status ?? this.status,
      currentScore: currentScore ?? this.currentScore,
      bestScore: bestScore ?? this.bestScore,
      totalScore: totalScore ?? this.totalScore,
      currentEquation: currentEquation ?? this.currentEquation,
      remainingTime: remainingTime ?? this.remainingTime,
      totalTime: totalTime ?? this.totalTime,
      consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentScore,
        bestScore,
        totalScore,
        currentEquation,
        remainingTime,
        totalTime,
        consecutiveCorrect,
      ];
}
