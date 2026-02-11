// ignore_for_file: avoid_print

import '../models/game_config.dart';
import '../models/math_operation.dart';
import 'difficulty_manager.dart';

/// Test file to demonstrate the new difficulty progression logic
void testDifficultyProgression() {
  print('=== TESTING DIFFICULTY PROGRESSION ===\n');
  
  // Test Case 1: All operations, max difficulty = 2
  print('TEST 1: All 4 operations, maxDifficulty = 2');
  print('Expected stages: 1+1, 1-1, 1×1, 1÷1, 1+2, 1-2, 1×2, 1÷2, 2+2, 2-2, 2×2, 2÷2');
  print('Total: 12 stages\n');
  
  final config1 = GameConfig(
    enabledOperations: {
      OperationType.add,
      OperationType.subtract,
      OperationType.multiply,
      OperationType.divide,
    },
    maxDifficultyLevel: 2,
    timeLimit: 2.0,
  );
  
  final stages1 = DifficultyManager.generateStages(config1);
  print('Generated ${stages1.length} stages:');
  for (int i = 0; i < stages1.length; i++) {
    final stage = stages1[i];
    final score = i * 100; // Each stage requires 100 points
    print('Stage ${i + 1} (Score: $score): ${stage.operand1Digits} ${stage.operation.symbol} ${stage.operand2Digits}');
  }
  
  print('\n---\n');
  
  // Test Case 2: All operations, max difficulty = 3
  print('TEST 2: All 4 operations, maxDifficulty = 3');
  print('Expected pattern:');
  print('  i=1: 1+1, 1-1, 1×1, 1÷1');
  print('  i=2: 1+2, 1-2, 1×2, 1÷2, 2+2, 2-2, 2×2, 2÷2');
  print('  i=3: 1+3, 1-3, 1×3, 1÷3, 2+3, 2-3, 2×3, 2÷3, 3+3, 3-3, 3×3, 3÷3');
  print('Total: 24 stages\n');
  
  final config2 = GameConfig(
    enabledOperations: {
      OperationType.add,
      OperationType.subtract,
      OperationType.multiply,
      OperationType.divide,
    },
    maxDifficultyLevel: 3,
    timeLimit: 2.0,
  );
  
  final stages2 = DifficultyManager.generateStages(config2);
  print('Generated ${stages2.length} stages:');
  
  // Group by i value for better visualization
  int currentI = 1;
  for (int idx = 0; idx < stages2.length; idx++) {
    final stage = stages2[idx];
    final score = idx * 100;
    
    // Check if we moved to next i group
    if (stage.operand2Digits > currentI) {
      currentI = stage.operand2Digits;
      print('');
    }
    
    print('Stage ${idx + 1} (Score: $score): ${stage.operand1Digits} ${stage.operation.symbol} ${stage.operand2Digits}');
  }
  
  print('\n---\n');
  
  // Test Case 3: Only Add and Multiply, max difficulty = 2
  print('TEST 3: Only Add (+) and Multiply (×), maxDifficulty = 2');
  print('Expected: 1+1, 1×1, 1+2, 1×2, 2+2, 2×2');
  print('Total: 6 stages\n');
  
  final config3 = GameConfig(
    enabledOperations: {
      OperationType.add,
      OperationType.multiply,
    },
    maxDifficultyLevel: 2,
    timeLimit: 2.0,
  );
  
  final stages3 = DifficultyManager.generateStages(config3);
  print('Generated ${stages3.length} stages:');
  for (int i = 0; i < stages3.length; i++) {
    final stage = stages3[i];
    final score = i * 100;
    print('Stage ${i + 1} (Score: $score): ${stage.operand1Digits} ${stage.operation.symbol} ${stage.operand2Digits}');
  }
  
  print('\n---\n');
  
  // Test Case 4: Score progression
  print('TEST 4: Score progression (maxDifficulty = 2, all operations)');
  print('Testing what stage player is at based on score:\n');
  
  final testScores = [0, 50, 99, 100, 200, 500, 1100, 1200];
  for (final score in testScores) {
    final stage = DifficultyManager.getCurrentStage(score, config1);
    final stageNum = DifficultyManager.getStageNumber(score, config1);
    final completed = DifficultyManager.hasCompletedAllStages(score, config1);
    print('Score $score -> Stage $stageNum: ${stage.operand1Digits} ${stage.operation.symbol} ${stage.operand2Digits} ${completed ? "(COMPLETED ALL!)" : ""}');
  }
  
  print('\n=== TEST COMPLETE ===');
}
