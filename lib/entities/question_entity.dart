import 'package:flutter/foundation.dart';

@immutable
class QuestionEntity {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> answers;

  const QuestionEntity({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  factory QuestionEntity.fromMap(Map<String, dynamic> map) {
    return QuestionEntity(
        category: map['category'],
        difficulty: map['difficulty'],
        correctAnswer: map['correct_answer'],
        answers: List<String>.from(map['incorrect_answers'])
          ..add(map['correct_answer'])
          ..shuffle(),
        question: map['question']);
  }
}
