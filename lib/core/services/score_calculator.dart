/// Service responsible for calculating scores based on reaction time
class ScoreCalculator {
  static const int maxScorePerQuestion = 20;

  /// Calculate score based on remaining time
  /// Formula: score = maxScore * (remainingTime / totalTime)
  static int calculateScore(double remainingTime, double totalTime) {
    if (totalTime <= 0) {
      return 0;
    }
    
    final ratio = (remainingTime / totalTime).clamp(0.0, 1.0);
    final score = (maxScorePerQuestion * ratio).round();
    
    // Ensure minimum score of 1 if answered in time
    return score.clamp(1, maxScorePerQuestion);
  }

  /// Get score multiplier text for display
  static String getScoreMultiplierText(double remainingTime, double totalTime) {
    final ratio = (remainingTime / totalTime).clamp(0.0, 1.0);
    
    if (ratio > 0.9) {
      return 'LIGHTNING FAST!';
    }
    if (ratio > 0.7) {
      return 'GREAT!';
    }
    if (ratio > 0.5) {
      return 'GOOD!';
    }
    if (ratio > 0.3) {
      return 'NICE!';
    }
    return 'OKAY!';
  }
}
