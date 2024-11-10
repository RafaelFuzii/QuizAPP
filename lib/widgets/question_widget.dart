import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;

  QuestionWidget({required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        for (int i = 0; i < question.options.length; i++)
          ListTile(
            title: Text(question.options[i]),
            leading: Radio(
              value: i,
              groupValue: question.correctAnswerIndex,
              onChanged: (value) {},
            ),
          ),
      ],
    );
  }
}
