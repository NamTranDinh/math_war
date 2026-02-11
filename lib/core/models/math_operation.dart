/// Enum representing the types of math operations
enum OperationType {
  add,
  subtract,
  multiply,
  divide,
}

extension OperationTypeExtension on OperationType {
  String get symbol {
    switch (this) {
      case OperationType.add:
        return '+';
      case OperationType.subtract:
        return '-';
      case OperationType.multiply:
        return '×';
      case OperationType.divide:
        return '÷';
    }
  }

  String get displayName {
    switch (this) {
      case OperationType.add:
        return 'Add (+)';
      case OperationType.subtract:
        return 'Sub (-)';
      case OperationType.multiply:
        return 'Mul (×)';
      case OperationType.divide:
        return 'Div (÷)';
    }
  }
}

/// Model representing a math equation
class MathEquation {
  final int operand1;
  final int operand2;
  final OperationType operation;
  final int displayedResult;
  final int correctResult;
  final bool isCorrect;

  MathEquation({
    required this.operand1,
    required this.operand2,
    required this.operation,
    required this.displayedResult,
    required this.correctResult,
    required this.isCorrect,
  });

  String get questionText {
    return '$operand1 ${operation.symbol} $operand2';
  }

  @override
  String toString() {
    return '$questionText = $displayedResult';
  }
}
