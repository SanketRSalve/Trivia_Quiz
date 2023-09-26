import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:trivia_quiz/controllers/quiz_controller.dart';
import 'package:trivia_quiz/controllers/quiz_state.dart';
import 'package:trivia_quiz/service/quiz_service.dart';

import 'models/question_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final dioProvider = Provider((ref) {
  return Dio(BaseOptions(baseUrl: 'https://opentdb.com/api.php?'));
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trivia Quiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

final quizQuestionProvider = FutureProvider<List<Question>>(
  (ref) => ref.watch(quizServiceProvider).getQuestions(),
);

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget _buildBody(
      BuildContext context,
      PageController pageController,
      List<Question> questions,
    ) {
      if (questions.isEmpty) return const Text("No questions found");
      final quizState = ref.watch(quizControllerProvider);
      return quizState.status == QuizStatus.complete
          ? QuizResults(state: quizState, questions: questions)
          : QuizQuestions(
              pageController: pageController,
              state: quizState,
              questions: questions,
            );
    }

    final pageController = usePageController();
    final result = ref.watch(quizQuestionProvider);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffd4418e), Color(0xff0652c5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: result.when(
            data: (questions) => _buildBody(context, pageController, questions),
            error: (e, _) => Center(child: Text(e.toString())),
            loading: () => CircularProgressIndicator()),
        bottomSheet: result.maybeWhen(
          data: (questions) {
            final quizState = ref.read(quizControllerProvider);
            if (!quizState.answered) return const SizedBox.shrink();
            return CustomButton(
                title: pageController.page!.toInt() + 1 < questions.length
                    ? 'Next Question'
                    : 'See Results',
                onTap: () {
                  ref
                      .read(quizControllerProvider.notifier)
                      .nextQuestion(questions, pageController.page!.toInt());
                  if (pageController.page!.toInt() + 1 < questions.length) {
                    pageController.nextPage(
                        duration: const Duration(
                          milliseconds: 250,
                        ),
                        curve: Curves.linear);
                  }
                });
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          borderRadius: BorderRadius.circular(25.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class QuizResults extends StatelessWidget {
  final QuizState state;
  final List<Question> questions;

  const QuizResults({super.key, required this.state, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${state.correct.length} / ${questions.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          'Correct',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 40.0,
        ),
        Consumer(
          builder: (context, ref, child) {
            return CustomButton(
                title: 'New Quiz',
                onTap: ref.read(quizControllerProvider.notifier).reset);
          },
        ),
      ],
    );
  }
}

class QuizQuestions extends StatelessWidget {
  final PageController pageController;
  final QuizState state;
  final List<Question> questions;

  const QuizQuestions(
      {super.key,
      required this.pageController,
      required this.state,
      required this.questions});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (BuildContext context, int index) {
        final question = questions[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${index + 1} of ${questions.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Text(
                question.question,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Divider(
              color: Colors.grey[200],
              height: 32.0,
              thickness: 2.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Consumer(
              builder: (context, ref, child) {
                return Column(
                  children: question.answers
                      .map(
                        (e) => AnswerCard(
                          answer: e,
                          isSelected: e == state.selectedAnswer,
                          isCorrect: e == question.correctAnswer,
                          isDisplayingAnswer: state.answered,
                          onTap: () => ref
                              .read(quizControllerProvider.notifier)
                              .submitAnswer(question, e),
                        ),
                      )
                      .toList(),
                );
              },
            )
          ],
        );
      },
    );
  }
}

class AnswerCard extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final bool isCorrect;
  final bool isDisplayingAnswer;
  final VoidCallback onTap;

  const AnswerCard(
      {super.key,
      required this.answer,
      required this.isSelected,
      required this.isCorrect,
      required this.isDisplayingAnswer,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 20.0,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isDisplayingAnswer
                  ? isCorrect
                      ? Colors.green
                      : isSelected
                          ? Colors.red
                          : Colors.white
                  : Colors.white,
              width: 4.0,
            ),
            borderRadius: BorderRadius.circular(100)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                answer,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: isDisplayingAnswer && isCorrect
                      ? FontWeight.bold
                      : FontWeight.w400,
                ),
              ),
            ),
            if (isDisplayingAnswer)
              isCorrect
                  ? const CircularIcon(icon: Icons.check, color: Colors.green)
                  : isSelected
                      ? const CircularIcon(
                          icon: Icons.close,
                          color: Colors.red,
                        )
                      : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class CircularIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const CircularIcon({super.key, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.0,
      width: 24.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 16.0,
      ),
    );
  }
}
