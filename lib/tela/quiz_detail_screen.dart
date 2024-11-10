import 'package:flutter/material.dart';
import 'package:flutter_app_quiz/models/quiz.dart';

class QuizDetailScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizDetailScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final Map<int, int> _selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _showResults,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.quiz.questions.length,
        itemBuilder: (context, index) {
          final question = widget.quiz.questions[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${index + 1}: ${question.text}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...question.options.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String option = entry.value;
                    return RadioListTile<int>(
                      title: Text(option),
                      value: idx,
                      groupValue: _selectedAnswers[question.id],
                      onChanged: (value) {
                        setState(() {
                          _selectedAnswers[question.id] = value!;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showResults() {
    int correctAnswers = 0;
    int incorrectAnswers = 0;

    for (var question in widget.quiz.questions) {
      int? selectedAnswer = _selectedAnswers[question.id];
      if (selectedAnswer != null) {
        if (selectedAnswer == question.correctAnswerIndex) {
          correctAnswers++;
        } else {
          incorrectAnswers++;
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Resultado do Quiz'),
          content: Text(
              'Acertos: $correctAnswers\nErros: $incorrectAnswers'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
