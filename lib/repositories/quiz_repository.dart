import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivia_quiz/main.dart';
import '../entities/question_entity.dart';

final quizRepoProvider = Provider<BaseQuizRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return QuizRepository(dio: dio);
});

abstract class BaseQuizRepo {
  Future<List<QuestionEntity>> getQuestions();
}

class QuizRepository implements BaseQuizRepo {
  final Dio dio;
  QuizRepository({required this.dio});

  @override
  Future<List<QuestionEntity>> getQuestions() async {
    try {
      // (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
      //     HttpClient()
      //       ..badCertificateCallback =
      //           (X509Certificate cert, String host, int port) => true;
      final response = await dio.get('', queryParameters: {
        'type': 'multiple',
        'amount': '10',
        'difficulty': 'easy',
      });

      final results = List<Map<String, dynamic>>.from(response.data['results']);
      final questions = results.map((e) => QuestionEntity.fromMap(e)).toList();

      return questions;
    } catch (e) {
      throw e.toString();
    }
  }
}
