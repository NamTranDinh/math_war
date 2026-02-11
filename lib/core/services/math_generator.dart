import 'dart:math';

import '../models/game_config.dart';
import '../models/math_operation.dart';
import 'difficulty_manager.dart';

/// Service responsible for generating math equations
class MathGenerator {
  final Random _random = Random();

  /// Generate a random math equation based on config and current score
  MathEquation generateEquation({
    required GameConfig config,
    required int currentScore,
  }) {
    // Get current difficulty stage based on score
    final stage = DifficultyManager.getCurrentStage(currentScore, config);

    // Use the stage's specified operation and digit counts
    final operation = stage.operation;
    int operand1 = _generateNumberForStage(
      stage.operand1Digits,
      minValue: stage.operand1Min,
      maxValue: stage.operand1Max,
    );
    int operand2 = _generateNumberForStage(
      stage.operand2Digits,
      minValue: stage.operand2Min,
      maxValue: stage.operand2Max,
    );

    // Special handling for division
    if (operation == OperationType.divide) {
      // Ensure division is exact (no remainder) and not dividing by 0
      operand2 = _adjustForDivision(
        operand1,
        operand2,
        stage.operand2Digits,
        minValue: stage.operand2Min,
        maxValue: stage.operand2Max,
      );
    }

    // Avoid negative results for subtraction
    if (operation == OperationType.subtract && operand2 > operand1) {
      final temp = operand1;
      operand1 = operand2;
      operand2 = temp;
    }

    // Calculate correct result
    final correctResult = _calculateResult(operand1, operand2, operation);

    // 50% chance to show correct or incorrect answer
    final showCorrect = _random.nextBool();
    int displayedResult;

    if (showCorrect) {
      displayedResult = correctResult;
    } else {
      displayedResult = _generateIncorrectResult(correctResult, operand1, operand2, operation);
    }

    if (operation == OperationType.subtract && displayedResult < 0) {
      displayedResult = displayedResult.abs();
    }

    return MathEquation(
      operand1: operand1,
      operand2: operand2,
      operation: operation,
      displayedResult: displayedResult,
      correctResult: correctResult,
      isCorrect: showCorrect,
    );
  }

  /// Generate a number with specified digit count
  int _generateNumber(int digits) {
    if (digits <= 0) {
      digits = 1;
    }
    if (digits > 5) {
      digits = 5;
    }

    final min = digits == 1 ? 1 : pow(10, digits - 1).toInt();
    final max = pow(10, digits).toInt() - 1;

    return min + _random.nextInt(max - min + 1);
  }

  int _generateNumberForStage(
    int digits, {
    int? minValue,
    int? maxValue,
  }) {
    if (minValue != null && maxValue != null) {
      if (maxValue <= minValue) {
        return minValue;
      }
      return minValue + _random.nextInt(maxValue - minValue + 1);
    }

    return _generateNumber(digits);
  }

  /// Adjust operand2 for division to ensure exact division
  /// Generates a proper divisor with the specified number of digits
  int _adjustForDivision(
    int operand1,
    int operand2Initial,
    int targetDigits, {
    int? minValue,
    int? maxValue,
  }) {
    // Get all divisors of operand1
    final divisors = _getDivisors(operand1);
    
    if (divisors.isEmpty) {
      return 1; // Fallback
    }
    
    // Filter divisors by range if provided, else by digit count
    final targetDivisors = divisors.where((d) {
      if (minValue != null && maxValue != null) {
        return d >= minValue && d <= maxValue;
      }
      final digitCount = d.toString().length;
      return digitCount == targetDigits;
    }).toList();
    
    // If we have divisors with target digits, pick one randomly
    if (targetDivisors.isNotEmpty) {
      return targetDivisors[_random.nextInt(targetDivisors.length)];
    }
    
    // If no divisors with target digits/range, pick the closest
    // Prefer divisors with fewer digits over more digits
    final sortedDivisors = divisors.toList()
      ..sort((a, b) {
        final aDiff = (a.toString().length - targetDigits).abs();
        final bDiff = (b.toString().length - targetDigits).abs();
        if (aDiff != bDiff) return aDiff.compareTo(bDiff);
        return b.compareTo(a); // Prefer larger divisor if same difference
      });
    
    return sortedDivisors.first;
  }

  /// Get all divisors of a number
  List<int> _getDivisors(int n) {
    final divisors = <int>[];
    
    // Only check up to sqrt(n) for efficiency
    final sqrtN = sqrt(n).toInt();
    
    for (int i = 1; i <= sqrtN; i++) {
      if (n % i == 0) {
        divisors.add(i);
        if (i != n ~/ i) {
          divisors.add(n ~/ i);
        }
      }
    }
    
    // Remove 0 and sort
    divisors.removeWhere((d) => d == 0);
    divisors.sort();
    
    return divisors;
  }

  /// Calculate the correct result
  int _calculateResult(int operand1, int operand2, OperationType operation) {
    switch (operation) {
      case OperationType.add:
        return operand1 + operand2;
      case OperationType.subtract:
        return operand1 - operand2;
      case OperationType.multiply:
        return operand1 * operand2;
      case OperationType.divide:
        return operand2 != 0 ? operand1 ~/ operand2 : 0;
    }
  }

  /// Generate a reasonable incorrect result
  /// The error should be noticeable but not too obvious
  int _generateIncorrectResult(int correctResult, int operand1, int operand2, OperationType operation) {
    // Calculate reasonable error range (10-50% of correct result or operands)
    final errorRange = max(
      (correctResult.abs() * 0.3).toInt(),
      max(operand1, operand2) ~/ 2,
    );

    if (errorRange == 0) {
      // For very small numbers
      final offset = _random.nextInt(5) + 1;
      return correctResult + (_random.nextBool() ? offset : -offset);
    }

    int incorrectResult;
    do {
      final error = _random.nextInt(errorRange) + 1;
      incorrectResult = correctResult + (_random.nextBool() ? error : -error);
      if (operation == OperationType.subtract && incorrectResult < 0) {
        incorrectResult = incorrectResult.abs();
      }
    } while (incorrectResult == correctResult);

    return incorrectResult;
  }
}
