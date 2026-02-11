// ignore_for_file: avoid_print

import 'package:math_war/core/models/game_config.dart';
import 'package:math_war/core/models/math_operation.dart';
import 'package:math_war/core/services/difficulty_manager.dart';

/// Demo script to test the new difficulty progression
void main() {
  print('🎮 MATH WAR - DIFFICULTY PROGRESSION DEMO\n');
  print('=' * 60);
  print('\n');
  
  // Demo 1: All operations, maxDifficulty = 2
  demo1();
  
  print('\n');
  print('=' * 60);
  print('\n');
  
  // Demo 2: All operations, maxDifficulty = 3  
  demo2();
  
  print('\n');
  print('=' * 60);
  print('\n');
  
  // Demo 3: Only specific operations
  demo3();
  
  print('\n');
  print('=' * 60);
  print('\n');
  
  // Demo 4: Score progression
  demo4();
  
  print('\n');
  print('=' * 60);
  print('\n✅ Demo Complete!\n');
}

void demo1() {
  print('📊 DEMO 1: All Operations, Max Difficulty = 2\n');
  
  final config = GameConfig(
    enabledOperations: {
      OperationType.add,
      OperationType.subtract,
      OperationType.multiply,
      OperationType.divide,
    },
    maxDifficultyLevel: 2,
    timeLimit: 2.0,
  );
  
  final stages = DifficultyManager.generateStages(config);
  print('Total Stages: ${stages.length}');
  print('Expected: 12 stages (4 ops × 3 combinations)\n');
  
  print('Pattern:');
  print('  i=1, j=1: 1+1, 1-1, 1×1, 1÷1     (4 stages)');
  print('  i=2, j=1: 1+2, 1-2, 1×2, 1÷2     (4 stages)');
  print('  i=2, j=2: 2+2, 2-2, 2×2, 2÷2     (4 stages)\n');
  
  for (int i = 0; i < stages.length; i++) {
    final stage = stages[i];
    final scoreRange = '${i * 100}-${(i + 1) * 100 - 1}';
    final stageNum = (i + 1).toString().padLeft(2);
    print('Stage $stageNum (Score: $scoreRange): '
        '${stage.operand1Digits}-digit ${stage.operation.symbol} '
        '${stage.operand2Digits}-digit');
  }
}

void demo2() {
  print('📊 DEMO 2: All Operations, Max Difficulty = 3\n');
  
  final config = GameConfig(
    enabledOperations: {
      OperationType.add,
      OperationType.subtract,
      OperationType.multiply,
      OperationType.divide,
    },
    maxDifficultyLevel: 3,
    timeLimit: 2.0,
  );
  
  final stages = DifficultyManager.generateStages(config);
  print('Total Stages: ${stages.length}');
  print('Expected: 24 stages\n');
  
  // Group by i value
  int lastI = 0;
  for (int idx = 0; idx < stages.length; idx++) {
    final stage = stages[idx];
    
    if (stage.operand2Digits != lastI) {
      lastI = stage.operand2Digits;
      print('\ni=$lastI:');
    }
    
    final scoreRange = '${idx * 100}-${(idx + 1) * 100 - 1}';
    final stageNum = (idx + 1).toString().padLeft(2);
    print('  Stage $stageNum ($scoreRange): '
        '${stage.operand1Digits}${stage.operation.symbol}'
        '${stage.operand2Digits}');
  }
}

void demo3() {
  print('📊 DEMO 3: Only Add (+) and Multiply (×), Max Difficulty = 2\n');
  
  final config = GameConfig(
    enabledOperations: {
      OperationType.add,
      OperationType.multiply,
    },
    maxDifficultyLevel: 2,
    timeLimit: 2.0,
  );
  
  final stages = DifficultyManager.generateStages(config);
  print('Total Stages: ${stages.length}');
  print('Expected: 6 stages (2 ops × 3 combinations)\n');
  
  for (int i = 0; i < stages.length; i++) {
    final stage = stages[i];
    final scoreRange = '${i * 100}-${(i + 1) * 100 - 1}';
    print('Stage ${i + 1} (Score: $scoreRange): '
        '${stage.operand1Digits} ${stage.operation.symbol} '
        '${stage.operand2Digits}');
  }
}

void demo4() {
  print('📊 DEMO 4: Score Progression Example\n');
  print('Config: All operations, maxDifficulty = 2\n');
  
  final config = GameConfig(
    enabledOperations: {
      OperationType.add,
      OperationType.subtract,
      OperationType.multiply,
      OperationType.divide,
    },
    maxDifficultyLevel: 2,
    timeLimit: 2.0,
  );
  
  final testScores = [
    0, 50, 99,      // Stage 1
    100, 150, 199,  // Stage 2
    500,            // Stage 6
    1100,           // Stage 12 (last)
    1200,           // Stage 12 (capped)
    5000,           // Stage 12 (capped)
  ];
  
  print('Score → Stage Mapping:\n');
  
  for (final score in testScores) {
    final stage = DifficultyManager.getCurrentStage(score, config);
    final stageNum = DifficultyManager.getStageNumber(score, config);
    final total = DifficultyManager.getTotalStages(config);
    final completed = DifficultyManager.hasCompletedAllStages(score, config);
    
    final statusEmoji = completed ? '🏆' : '▶️';
    print('$statusEmoji Score $score → Stage $stageNum/$total: '
        '${stage.operand1Digits}${stage.operation.symbol}'
        '${stage.operand2Digits}'
        '${completed ? " (ALL STAGES COMPLETED!)" : ""}');
  }
  
  print('\nKey Points:');
  print('  • Every 100 points = next stage');
  print('  • Answer fast = reach higher stages faster');
  print('  • After completing all stages, stay at final stage');
}
