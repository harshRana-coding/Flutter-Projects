import 'package:flutter/material.dart';

class QuestionSummary extends StatelessWidget {
  const QuestionSummary(this.summary, {super.key});
  final List<Map<String, Object>> summary;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: summary.map((data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8,),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: (data['user-answer'] == data['correct-answer'])
                          ?const Color.fromARGB(255, 95, 230, 232)
                          : const Color.fromARGB(255, 245, 150, 253),
                          borderRadius: BorderRadius.circular(100)),
                          alignment: Alignment.center,
                    child: Text(
                      ((data['question_index'] as int) + 1).toString(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['question'] as String,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(data['user-answer'] as String,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 213, 143, 236))),
                          Text(data['correct-answer'] as String,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 107, 178, 236))),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
