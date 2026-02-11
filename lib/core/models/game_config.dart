import 'package:equatable/equatable.dart';
import 'math_operation.dart';

/// Configuration for the game settings
class GameConfig extends Equatable {
  final Set<OperationType> enabledOperations;
  final int maxDifficultyLevel; // 1-5 (represents max digit count)
  final double timeLimit; // in seconds (1.0 - 5.0)

  const GameConfig({
    required this.enabledOperations,
    required this.maxDifficultyLevel,
    required this.timeLimit,
  });

  /// Default configuration
  factory GameConfig.defaultConfig() {
    return const GameConfig(
      enabledOperations: {
        OperationType.add,
      },
      maxDifficultyLevel: 1,
      timeLimit: 2.0,
    );
  }

  GameConfig copyWith({
    Set<OperationType>? enabledOperations,
    int? maxDifficultyLevel,
    double? timeLimit,
  }) {
    return GameConfig(
      enabledOperations: enabledOperations ?? this.enabledOperations,
      maxDifficultyLevel: maxDifficultyLevel ?? this.maxDifficultyLevel,
      timeLimit: timeLimit ?? this.timeLimit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabledOperations': enabledOperations.map((e) => e.index).toList(),
      'maxDifficultyLevel': maxDifficultyLevel,
      'timeLimit': timeLimit,
    };
  }

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      enabledOperations: (json['enabledOperations'] as List)
          .map((e) => OperationType.values[e as int])
          .toSet(),
      maxDifficultyLevel: json['maxDifficultyLevel'] as int,
      timeLimit: (json['timeLimit'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [enabledOperations, maxDifficultyLevel, timeLimit];
}
