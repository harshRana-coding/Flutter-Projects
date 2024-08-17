import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class StartScreen extends StatelessWidget {
  const StartScreen(this.startQuiz,{super.key});
  final void Function() startQuiz;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/quiz_logo.png',
              width: 300,
              color: const Color.fromARGB(147, 255, 255, 255),
            ),
            const SizedBox(
              height: 60,
            ),
            Text(
              "Learn flutter a fun way!!",
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
                onPressed: startQuiz,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_right_alt_sharp,
                  size: 40,
                ),
                label: const Text(
                  "Start Quiz",
                ))
          ],
        ),
      );
  }
}
