// Import this for the Timer
import 'dart:async';
import 'dart:ui';

//TODO: Step 2 - Import the rFlutter_Alert package here.
import 'package:quizzler/Quiz_brain.dart';
import 'package:quizzler/ScoreCalculator.dart';

Quiz_brain quizBrain = Quiz_brain();
ScoreCalculator calculator = ScoreCalculator();

class MyTimer {
  int timeLeft = 900; // 120 seconds countdown
  Timer? countdownTimer;
  VoidCallback? onTick;

  // Method to start the timer

  void startTimer(VoidCallback onTick) {
    this.onTick = onTick;
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        timeLeft--;
        onTick(); // Trigger the UI update on every tick
      } else {
        timer.cancel();
        timeLeft = 900;
        onTick(); // Final UI update when the time is up
      }
    });
  }

  // Method to stop the timer
  void stopTimer() {
    countdownTimer?.cancel();
    timeLeft = 900; // Reset the timer
  }

  // Method to get the formatted time (minutes:seconds)
  String getFormattedTime() {
    int minutes = timeLeft ~/ 60;
    int seconds = timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
