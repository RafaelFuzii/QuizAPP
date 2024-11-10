import 'dart:convert';

import 'package:flutter_app_quiz/models/quiz.dart';
import 'package:http/http.dart' as http;

class QuizService {
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Quiz>> fetchQuizzes() async {
    final response = await http.get(Uri.parse('$baseUrl/quizzes'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Quiz.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  Future<void> addQuiz(Quiz quiz) async {
    final response = await http.post(
      Uri.parse('$baseUrl/quizzes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(quiz.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add quiz');
    }
  }

  Future<void> updateQuiz(Quiz quiz) async {
    final response = await http.put(
      Uri.parse('$baseUrl/quizzes/${quiz.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(quiz.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update quiz');
    }
  }

  Future<void> deleteQuiz(int quizId) async {
    final url = Uri.parse('$baseUrl/quizzes/$quizId');
    print('Tentando excluir o quiz com URL: $url');

    final response = await http.delete(url);


    if (response.statusCode == 200) {
      print('Quiz excluído com sucesso!');
    } else {
      print('Erro ao excluir quiz: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to delete quiz');
    }
  }

}
