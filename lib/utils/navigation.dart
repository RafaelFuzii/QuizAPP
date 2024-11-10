import 'package:flutter/material.dart';
import '../tela/dashboard.dart';
import '../tela/listar_quiz.dart';
import '../tela/quiz_form.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    QuizListScreen(),
    QuizFormScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Quizzes'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Adicionar Quiz'),
        ],
      ),
    );
  }
}
