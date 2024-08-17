import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/question_summary.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.chosenAnswers,required this.restart});
  final List<String> chosenAnswers;
  final void Function() restart;
  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];
    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'correct-answer': questions[i].answers[0],
        'user-answer': chosenAnswers[i],
      });
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summary = getSummaryData();
    final numOfQuestions = questions.length;
    final correctQuestions = summary.where((data) {
      return data['user-answer'] == data['correct-answer'];
    }).length;
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You answered $correctQuestions out of $numOfQuestions questions correctly.",
              style: const TextStyle(
                color: Color.fromARGB(255, 229, 124, 229),
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            QuestionSummary(summary),
            const SizedBox(
              height: 30,
            ),
            TextButton.icon(
              onPressed: restart,
              icon: const Icon(
                Icons.restart_alt,
                color: Colors.white,
              ),
              label: const Text(
                'Restart Quiz!',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
