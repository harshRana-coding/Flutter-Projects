import 'package:flutter/material.dart';
import 'package:quiz_app/question_screen.dart';
import 'package:quiz_app/result_screen.dart';
import 'package:quiz_app/start_screen.dart';
import 'package:quiz_app/data/questions.dart';
class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<Quiz> createState() {
    return _Quiz();
  }
}

class _Quiz extends State<Quiz> {
  String activeScreen = "StartScreen";
  List<String> selectedAnswers  = [];
  void switchScreen(){
    setState(() {
      activeScreen = "QuestionScreen";
    });
  }
  void restartQuiz(){
    setState(() {
       selectedAnswers  = [];
       activeScreen = "QuestionScreen";
    });
  }
  void chooseAnswer(String answer){
    selectedAnswers.add(answer);
    if(selectedAnswers.length==questions.length){
      setState(() {
        activeScreen = "ResultScreen";
      });
    }
  }
  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: (activeScreen == "StartScreen")?StartScreen(switchScreen):(activeScreen=="ResultScreen")? ResultScreen(chosenAnswers: selectedAnswers,restart : restartQuiz): QuestionScreen(onSelectAnswer: chooseAnswer),
        ),
      ),
    );
  }
}
