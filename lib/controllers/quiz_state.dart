// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../models/question_model.dart';

enum QuizStatus {
  initial,
  correct,
  incorrect,
  complete,
}

class QuizState {
  final String selectedAnswer;
  final List<Question> correct;
  final List<Question> incorrect;
  final QuizStatus status;
  QuizState({
    required this.selectedAnswer,
    required this.correct,
    required this.incorrect,
    required this.status,
  });

  factory QuizState.initial() {
    return QuizState(
        selectedAnswer: '',
        correct: [],
        incorrect: [],
        status: QuizStatus.initial);
  }

  QuizState copyWith({
    String? selectedAnswer,
    List<Question>? correct,
    List<Question>? incorrect,
    QuizStatus? status,
  }) {
    return QuizState(
        selectedAnswer: selectedAnswer ?? this.selectedAnswer,
        correct: correct ?? this.correct,
        incorrect: incorrect ?? this.incorrect,
        status: status ?? this.status);
  }

  bool get answered =>
      status == QuizStatus.correct || status == QuizStatus.incorrect;

  @override
  bool operator ==(covariant QuizState other) {
    if (identical(this, other)) return true;

    return other.selectedAnswer == selectedAnswer &&
        listEquals(other.correct, correct) &&
        listEquals(other.incorrect, incorrect) &&
        other.status == status;
  }

  @override
  int get hashCode {
    return selectedAnswer.hashCode ^
        correct.hashCode ^
        incorrect.hashCode ^
        status.hashCode;
  }
}
