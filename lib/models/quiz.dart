import 'package:flutter_app_quiz/models/question.dart';

class Quiz {
  final int id;
  final String title;
  final List<Question> questions;

  Quiz({required this.id, required this.title, this.questions = const []});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id:  int.parse(json['id'].toString()),
      title: json['title'],
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'questions': questions.map((e) => e.toJson()).toList(),
  };
}
