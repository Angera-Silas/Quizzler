class ScoreCalculator {
  int _score = 0, _totalQuestions = 0;
  void getParameters(
      {int userCorrectAnswers = 0, int totalAnsweredQuestions = 0}) {
    _score = userCorrectAnswers;
    _totalQuestions = totalAnsweredQuestions;
  }

  double calculateScore() {
    double p = (_score / _totalQuestions) * 100;
    if (p <= 0.0) {
      p = 1.0;
    }
    return p;
  }

  String displayScore() {
    double score = calculateScore();
    String formattedScore = score.toStringAsFixed(2);
    if (score >= 70.0) {
      return "Excellent!\nYou got $_score / $_totalQuestions\nScore: $formattedScore %";
    } else if (score >= 50.0) {
      return "Good Work!\nYou got $_score / $_totalQuestions\nScore: $formattedScore %";
    } else {
      return "Poor! \nYou got $_score / $_totalQuestions\nScore: $formattedScore %";
    }
  }
}
