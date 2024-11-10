import 'package:flutter/material.dart';
import 'package:flutter_app_quiz/utils/navigation.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Navigation(), // A tela principal, que você definiu
    );
  }
}
