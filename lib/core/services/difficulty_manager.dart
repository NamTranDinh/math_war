import '../models/game_config.dart';
import '../models/math_operation.dart';

/// Manages difficulty progression based on score
/// Pattern:
/// - For each digit pair stage (j-digit operand1, i-digit operand2):
///   Start with smaller ranges, then expand to full range
///   Example:
///     1-digit: 1-5 → 1-9
///     2-digit: 10-20 → 10-99
/// - For each enabled operation (+, -, ×, ÷)
class DifficultyManager {
  /// Generate all difficulty stages based on maxDifficultyLevel and enabled operations
  /// Returns a list of DifficultyStage objects in progression order
  static List<DifficultyStage> generateStages(GameConfig config) {
    final List<DifficultyStage> stages = [];
    final operations = config.enabledOperations.toList()..sort((a, b) => a.index.compareTo(b.index));

    // Pattern: For i from 1 to maxDifficulty
    for (int i = 1; i <= config.maxDifficultyLevel; i++) {
      // For j from 1 to i
      for (int j = 1; j <= i; j++) {
        final op1Ranges = _getRangesForDigits(j);
        final op2Ranges = _getRangesForDigits(i);

        // First: smaller ranges
        for (final operation in operations) {
          stages.add(DifficultyStage(
            operand1Digits: j,
            operand2Digits: i,
            operation: operation,
            operand1Min: op1Ranges.smallMin,
            operand1Max: op1Ranges.smallMax,
            operand2Min: op2Ranges.smallMin,
            operand2Max: op2Ranges.smallMax,
          ));
        }

        // Then: full ranges
        for (final operation in operations) {
          stages.add(DifficultyStage(
            operand1Digits: j,
            operand2Digits: i,
            operation: operation,
            operand1Min: op1Ranges.fullMin,
            operand1Max: op1Ranges.fullMax,
            operand2Min: op2Ranges.fullMin,
            operand2Max: op2Ranges.fullMax,
          ));
        }
      }
    }
    
    return stages;
  }
  
  /// Get the current stage based on score
  /// Every 100 points advances to the next stage
  static DifficultyStage getCurrentStage(int score, GameConfig config) {
    final stages = generateStages(config);
    
    if (stages.isEmpty) {
      // Fallback if no operations enabled (shouldn't happen)
      return const DifficultyStage(
        operand1Digits: 1,
        operand2Digits: 1,
        operation: OperationType.add,
      );
    }
    
    // Calculate stage index: every 100 points = 1 stage
    final stageIndex = (score ~/ 100).clamp(0, stages.length - 1);
    
    return stages[stageIndex];
  }
  
  /// Get stage number (1-based) for display purposes
  static int getStageNumber(int score, GameConfig config) {
    final stages = generateStages(config);
    if (stages.isEmpty) {
      return 1;
    }
    
    final stageIndex = (score ~/ 100).clamp(0, stages.length - 1);
    return stageIndex + 1;
  }
  
  /// Get total number of stages
  static int getTotalStages(GameConfig config) {
    return generateStages(config).length;
  }
  
  /// Check if player has completed all stages
  static bool hasCompletedAllStages(int score, GameConfig config) {
    final stages = generateStages(config);
    if (stages.isEmpty) {
      return false;
    }
    
    final stageIndex = score ~/ 100;
    return stageIndex >= stages.length - 1;
  }
}

class _DigitRanges {
  const _DigitRanges({
    required this.smallMin,
    required this.smallMax,
    required this.fullMin,
    required this.fullMax,
  });

  final int smallMin;
  final int smallMax;
  final int fullMin;
  final int fullMax;
}

_DigitRanges _getRangesForDigits(int digits) {
  if (digits <= 1) {
    return const _DigitRanges(
      smallMin: 1,
      smallMax: 5,
      fullMin: 1,
      fullMax: 9,
    );
  }

  final base = 1;
  int min = 1;
  for (int i = 1; i < digits; i++) {
    min *= 10;
  }
  final max = (min * 10) - 1;
  final smallMax = min * 2;

  return _DigitRanges(
    smallMin: min,
    smallMax: smallMax,
    fullMin: min,
    fullMax: max,
  );
}

/// Represents a single difficulty stage with specific operand digits and operation
class DifficultyStage {
  /// Number of digits in first operand
  final int operand1Digits;
  /// Number of digits in second operand
  final int operand2Digits;
  /// Operation type for this stage
  final OperationType operation;
  /// Optional min/max range for operand1
  final int? operand1Min;
  final int? operand1Max;
  /// Optional min/max range for operand2
  final int? operand2Min;
  final int? operand2Max;

  /// Creates a difficulty stage
  const DifficultyStage({
    required this.operand1Digits,
    required this.operand2Digits,
    required this.operation,
    this.operand1Min,
    this.operand1Max,
    this.operand2Min,
    this.operand2Max,
  });

  @override
  String toString() {
    final rangeInfo = (operand1Min != null && operand1Max != null)
        ? ' ($operand1Min-$operand1Max)'
        : '';
    return '$operand1Digits-digit${rangeInfo} ${operation.symbol} $operand2Digits-digit';
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyStage &&
          runtimeType == other.runtimeType &&
          operand1Digits == other.operand1Digits &&
          operand2Digits == other.operand2Digits &&
          operation == other.operation &&
          operand1Min == other.operand1Min &&
          operand1Max == other.operand1Max &&
          operand2Min == other.operand2Min &&
          operand2Max == other.operand2Max;

  @override
  int get hashCode =>
      operand1Digits.hashCode ^
      operand2Digits.hashCode ^
      operation.hashCode ^
      operand1Min.hashCode ^
      operand1Max.hashCode ^
      operand2Min.hashCode ^
      operand2Max.hashCode;
}
