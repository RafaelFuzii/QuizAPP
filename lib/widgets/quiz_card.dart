import 'package:flutter/material.dart';
import '../models/quiz.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;

  QuizCard({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(quiz.title),
        subtitle: Text('${quiz.questions.length} Perguntas'),
      ),
    );
  }
}
