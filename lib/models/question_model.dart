// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:trivia_quiz/entities/entities.dart';

@immutable
class Question {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> answers;

  const Question(
    this.category,
    this.difficulty,
    this.question,
    this.correctAnswer,
    this.answers,
  );

  factory Question.fromEntity(QuestionEntity questionEntity) {
    return Question(
        questionEntity.category,
        questionEntity.difficulty,
        questionEntity.question,
        questionEntity.correctAnswer,
        questionEntity.answers);
  }

  @override
  bool operator ==(covariant Question other) {
    if (identical(this, other)) return true;

    return other.category == category &&
        other.difficulty == difficulty &&
        other.question == question &&
        other.correctAnswer == correctAnswer &&
        listEquals(other.answers, answers);
  }

  @override
  int get hashCode {
    return category.hashCode ^
        difficulty.hashCode ^
        question.hashCode ^
        correctAnswer.hashCode ^
        answers.hashCode;
  }
}
