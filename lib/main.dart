import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizzler/Quiz_brain.dart';
import 'package:quizzler/ScoreCalculator.dart';
import 'package:quizzler/Timer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Quiz_brain quizBrain = Quiz_brain();
ScoreCalculator calculator = ScoreCalculator();
MyTimer stopwatch = MyTimer();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade500,
          foregroundColor: Colors.white,
          elevation: 0.0,
          primary: true,
          toolbarHeight: 75,
          shadowColor: Colors.blueGrey.shade600,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
            ),
            tooltip: 'Menu',
            onPressed: () {},
          ),
          title: const Text(
            "Quizller App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26.0,
            ),
          ),
          //toolbarHeight: 90,
          centerTitle: true,

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Center(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.person),
                  ),
                ),
              ),
            )
          ],

          // shape: const RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(15),
          //     bottomRight: Radius.circular(15),
          //   ),
          // ),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const <StretchMode>[
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
          ),

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(40.0),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int correctAnswers = 0;
  String alertTitle = '';
  String alertMessage = '';
  AlertType alert = AlertType.info;

  @override
  void initState() {
    super
        .initState(); //Polymorphism - this will start the timer when Quizpage is fully loaded.
    //Start the timer when the quiz starts and trigger UI update on every tick
    stopwatch.startTimer(() {
      setState(() {
        if (stopwatch.timeLeft == 0) {
          alertTitle = "Time is Up!";
          alertMessage = calculator.displayScore();
          alert = AlertType.warning;
          _showAlert();
        }
      });
    });
  }

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();
    setState(() {
      if (quizBrain.isFinished() == true || stopwatch.timeLeft <= 0) {
        if (quizBrain.isFinished() == true) {
          alertTitle = "Quiz Completed";
          alertMessage = calculator.displayScore();
          alert = AlertType.success;
          stopwatch.stopTimer();
        }
        _showAlert();
      } else {
        if (scoreKeeper.length <= quizBrain.getTotalQuestions()) {
          if (userPickedAnswer == correctAnswer) {
            scoreKeeper.add(const Icon(Icons.check, color: Colors.green));
            correctAnswers++;
          } else {
            scoreKeeper.add(const Icon(Icons.close, color: Colors.red));
          }
          quizBrain.nextQuestion();
          calculator.getParameters(
              userCorrectAnswers: correctAnswers,
              totalAnsweredQuestions: scoreKeeper.length);
        } else {
          setState(() {
            stopwatch.stopTimer();
          });
        }
      }
    });
  }

//A private method used to display alerts to the user. - Encapsulation
  void _showAlert() {
    Alert(
      context: context,
      title: alertTitle,
      type: alert,
      desc: alertMessage,
      buttons: [
        DialogButton(
          onPressed: () {
            // Reset the quiz questions and internal state
            quizBrain.reset();
            setState(() {
              // Clear the current score icons
              scoreKeeper.clear();
              correctAnswers = 0;
            });

            // Restart the timer and update UI on every tick
            stopwatch.startTimer(() {
              setState(() {
                if (stopwatch.timeLeft == 0) {
                  // Time's up! Show an alert
                  alertTitle = "Time is Up!";
                  alertMessage = calculator.displayScore();
                  alert = AlertType.warning;
                  _showAlert();
                }
              });
            });

            // Close the alert dialog
            Navigator.pop(context);
          },
          color: const Color.fromRGBO(0, 179, 134, 1.0),
          child: const Text(
            "TRY AGAIN",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          onPressed: () => exit(0),
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
          child: const Text(
            "QUIT",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  Padding _showBtn(bool checkValue, String name) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          backgroundColor:
              WidgetStateProperty.all<Color>(Colors.blueGrey.shade400),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            // if (states.contains(WidgetState.hovered)) {
            //   return Colors.amber.withOpacity(0.9);
            // }
            if (states.contains(WidgetState.focused) ||
                states.contains(WidgetState.pressed)) {
              return Colors.amber.shade500;
            }
            return null;
          }),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
        onPressed: () {
          checkAnswer(checkValue);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: Colors.amber.shade500,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => exit(0),
                  child: const Text(
                    'QUIT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    "Time Left: ${stopwatch.getFormattedTime()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: _showBtn(true, "True"),
                  ),
                  Expanded(
                    child: _showBtn(false, "False"),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: scoreKeeper,
          ),
        )
      ],
    );
  }
}
