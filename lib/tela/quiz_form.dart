import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';

class QuizFormScreen extends StatefulWidget {
  @override
  _QuizFormScreenState createState() => _QuizFormScreenState();
}

class _QuizFormScreenState extends State<QuizFormScreen> {
  final _quizService = QuizService();
  final _titleController = TextEditingController();
  final List<Question> _questions = [];
  bool _isLoading = false;

  Future<void> _submitQuiz() async {
    if (_titleController.text.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha o título e adicione perguntas.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final quiz = Quiz(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      questions: _questions,
    );

    try {
      await _quizService.addQuiz(quiz);
      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizSavedScreen()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar quiz. Tente novamente.')),
      );
    }
  }

  void _addQuestion() {
    setState(() {
      _questions.add(Question(
        id: _questions.length + 1,
        text: '',
        options: List.filled(4, ''),
        correctAnswerIndex: 0,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Novo Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título do Quiz'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Adicionar Pergunta'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return QuestionForm(
                    question: _questions[index],
                    onUpdate: (updatedQuestion) {
                      setState(() {
                        _questions[index] = updatedQuestion;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitQuiz,
              child: _isLoading ? CircularProgressIndicator() : Text('Salvar Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionForm extends StatefulWidget {
  final Question question;
  final ValueChanged<Question> onUpdate;

  QuestionForm({required this.question, required this.onUpdate});

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.question.text;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Texto da Pergunta'),
              onChanged: (value) {
                widget.onUpdate(widget.question.copyWith(text: value));
              },
            ),
            SizedBox(height: 10),
            ...List.generate(widget.question.options.length, (index) {
              return ListTile(
                title: TextField(
                  decoration: InputDecoration(labelText: 'Opção ${index + 1}'),
                  onChanged: (value) {
                    final updatedOptions = List<String>.from(widget.question.options);
                    updatedOptions[index] = value;
                    widget.onUpdate(widget.question.copyWith(options: updatedOptions));
                  },
                ),
                leading: Radio<int>(
                  value: index,
                  groupValue: widget.question.correctAnswerIndex,
                  onChanged: (value) {
                    widget.onUpdate(widget.question.copyWith(correctAnswerIndex: value!));
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class QuizSavedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizFormScreen()),
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text('Quiz Salvo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Quiz salvo com sucesso!'),
          ],
        ),
      ),
    );
  }
}
