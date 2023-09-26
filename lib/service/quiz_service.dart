import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivia_quiz/repositories/repositories.dart';

import '../models/question_model.dart';

final quizServiceProvider = Provider<BaseQuizService>((ref) {
  final quizRepo = ref.watch(quizRepoProvider);
  return QuizService(quizRepo);
});

abstract class BaseQuizService {
  Future<List<Question>> getQuestions();
}

class QuizService implements BaseQuizService {
  final BaseQuizRepo _quizRepository;
  QuizService(this._quizRepository);
  @override
  Future<List<Question>> getQuestions() async {
    try {
      final questionEntities = await _quizRepository.getQuestions();
      final questions =
          questionEntities.map((e) => Question.fromEntity(e)).toList();

      return questions;
    } catch (e) {
      throw e.toString();
    }
  }
}
