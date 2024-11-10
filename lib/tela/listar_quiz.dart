import 'package:flutter/material.dart';
import 'package:flutter_app_quiz/models/quiz.dart';
import 'package:flutter_app_quiz/services/quiz_service.dart';
import 'package:flutter_app_quiz/tela/quiz_detail_screen.dart';

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  final QuizService quizService = QuizService();
  late Future<List<Quiz>> futureQuizzes;

  @override
  void initState() {
    super.initState();
    futureQuizzes = quizService.fetchQuizzes();
  }

  Future<void> _deleteQuiz(int quizId) async {
    await quizService.deleteQuiz(quizId);

    setState(() {
      futureQuizzes = quizService.fetchQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes'),
      ),
      body: FutureBuilder<List<Quiz>>(
        future: futureQuizzes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No quizzes available.'));
          } else {
            final quizzes = snapshot.data!;
            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return ListTile(
                  title: Text(quiz.title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Excluir Quiz'),
                            content: Text('Você tem certeza que deseja excluir este quiz?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteQuiz(quiz.id);
                                  Navigator.pop(context);
                                },
                                child: Text('Excluir'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizDetailScreen(quiz: quiz),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
